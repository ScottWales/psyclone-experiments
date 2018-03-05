!> 
!! Copyright 2018 Scott Wales
!!
!! \author  Scott Wales <scottwales@outlook.com.au>
!!
!! Licensed under the Apache License, Version 2.0 (the "License");
!! you may not use this file except in compliance with the License.
!! You may obtain a copy of the License at
!!
!!     http://www.apache.org/licenses/LICENSE-2.0
!!
!! Unless required by applicable law or agreed to in writing, software
!! distributed under the License is distributed on an "AS IS" BASIS,
!! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!! See the License for the specific language governing permissions and
!! limitations under the License.

module sqlite_mod
    use, intrinsic :: iso_c_binding, only: c_ptr, c_null_ptr
    implicit none
    private
    public sqlite_db_t
    public sqlite_stmt_t
    public sqlite_open

    type :: sqlite_db_t
        type(c_ptr) :: impl = c_null_ptr
    contains
        procedure :: close => sqlite_close
        procedure :: prepare => sqlite_prepare
    end type

    type :: sqlite_stmt_t
        type(c_ptr) :: impl = c_null_ptr
    contains
        procedure :: finalize => stmt_finalize
        procedure :: step => stmt_step

        procedure :: bind_int => stmt_bind_int
        procedure :: bind_text => stmt_bind_text

        procedure :: column_int => stmt_column_int
        procedure :: column_text => stmt_column_text
    end type

contains

    function sqlite_open(filename, ierr) result(r)
        use, intrinsic :: iso_c_binding, only: c_null_char
        use sqlite_c_mod

        character(len=*), intent(in) :: filename
        integer, intent(out) :: ierr
        type(sqlite_db_t) :: r

        ierr = sqlite3_open(filename//c_null_char, r%impl)
    end function

    subroutine sqlite_close(self, ierr)
        use sqlite_c_mod

        class(sqlite_db_t), intent(in) :: self
        integer, intent(out) :: ierr
        
        ierr = sqlite3_close(self%impl)
    end subroutine

    function sqlite_prepare(self, sql, ierr) result(r)
        use sqlite_c_mod

        class(sqlite_db_t), intent(in) :: self
        character(len=*), intent(in) :: sql
        integer, intent(out) :: ierr
        type(sqlite_stmt_t) :: r
        type(c_ptr) :: tail

        ierr = sqlite3_prepare_v2(self%impl, sql, len(sql), r%impl, tail)  
    end function

    subroutine stmt_finalize(self, ierr)
        use sqlite_c_mod

        class(sqlite_stmt_t), intent(in) :: self
        integer, intent(out) :: ierr

        ierr = sqlite3_finalize(self%impl)
    end subroutine

    subroutine stmt_step(self, ierr)
        use sqlite_c_mod

        class(sqlite_stmt_t), intent(in) :: self
        integer, intent(out) :: ierr

        ierr = sqlite3_step(self%impl)
    end subroutine

    subroutine stmt_bind_int(self, idx, val, ierr)
        use sqlite_c_mod

        class(sqlite_stmt_t), intent(in) :: self
        integer, intent(in) :: idx
        integer, intent(in) :: val
        integer, intent(out) :: ierr

        ierr = sqlite3_bind_int(self%impl, idx, val)
    end subroutine

    subroutine stmt_bind_text(self, idx, val, ierr)
        use sqlite_c_mod

        class(sqlite_stmt_t), intent(in) :: self
        integer, intent(in) :: idx
        character(len=*), intent(in) :: val
        integer, intent(out) :: ierr

        ierr = sqlite_helper_bind_text(self%impl, idx, val, len(val))
    end subroutine

    function stmt_column_int(self, col) result(r)
        use sqlite_c_mod

        class(sqlite_stmt_t), intent(in) :: self
        integer, intent(in) :: col
        integer :: r

        r = sqlite3_column_int(self%impl, col)
    end function

    function stmt_column_text(self, col) result(r)
        use sqlite_c_mod

        class(sqlite_stmt_t), intent(in) :: self
        integer, intent(in) :: col
        character(len=:), allocatable :: r

        type(c_ptr) :: cptr
        integer :: len

        cptr = sqlite_helper_column_text(self%impl, col, len)
        allocate(character(len=len) :: r)
        r = transfer(cptr, r)
    end function

end module
