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

module sqlite_c_mod
    implicit none
    public

    interface
        function sqlite3_open(filename, ppdb) bind(c) result(r)
            use, intrinsic :: iso_c_binding
            character(kind=c_char, len=1), dimension(*), intent(in) :: filename
            type(C_PTR), intent(out) :: ppdb
            integer(c_int) :: r
        end function

        function sqlite3_close(db) bind(c) result(r)
            use, intrinsic :: iso_c_binding
            type(C_PTR), intent(in), value :: db
            integer(c_int) :: r
        end function

        function sqlite3_prepare_v2(db, sql, nbyte, stmt, tail) bind(c) &
                result(r)
            use, intrinsic :: iso_c_binding
            type(C_PTR), intent(in), value :: db
            character(kind=c_char, len=1), dimension(*), intent(in) :: sql
            integer(c_int), value :: nbyte
            type(C_PTR), intent(out) :: stmt
            type(C_PTR), intent(out) :: tail
            integer(c_int) :: r
        end function

        function sqlite3_step(stmt) bind(c) result(r)
            use, intrinsic :: iso_c_binding
            type(C_PTR), intent(in), value :: stmt
            integer(c_int) :: r
        end function

        function sqlite3_finalize(stmt) bind(c) result(r)
            use, intrinsic :: iso_c_binding
            type(C_PTR), intent(in), value :: stmt
            integer(c_int) :: r
        end function

        function sqlite3_column_int(stmt, col) bind(c) result(r)
            use, intrinsic :: iso_c_binding
            type(C_PTR), intent(in), value :: stmt
            integer(c_int), intent(in), value :: col
            integer(c_int) :: r
        end function

        function sqlite_helper_column_text(stmt, col, len) bind(c) result(r)
            use, intrinsic :: iso_c_binding
            type(C_PTR), intent(in), value :: stmt
            integer(c_int), intent(in), value :: col
            integer(c_int), intent(out) :: len
            type(C_PTR) :: r
        end function

        function sqlite3_bind_int(stmt, idx, val) bind(c) result(r)
            use, intrinsic :: iso_c_binding
            type(C_PTR), intent(in), value :: stmt
            integer(c_int), intent(in), value :: idx
            integer(c_int), intent(in), value :: val
            integer(c_int) :: r
        end function

        function sqlite_helper_bind_text(stmt, idx, val, len) bind(c) result(r)
            use, intrinsic :: iso_c_binding
            type(C_PTR), intent(in), value :: stmt
            integer(c_int), intent(in), value :: idx
            character(kind=c_char, len=1), dimension(*), intent(in) :: val
            integer(c_int), intent(in), value :: len
            integer(c_int) :: r
        end function

    end interface
end module
