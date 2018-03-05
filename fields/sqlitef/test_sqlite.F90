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

#define assert_zero(check) assert_zero_impl(check, "check", __FILE__, __LINE__, db)
subroutine assert_zero_impl(check, checkstr, filename, line, db)
    use sqlite_mod
    integer, intent(in) :: check
    character(len=*), intent(in) :: checkstr, filename
    integer, intent(in) :: line
    type(sqlite_db_t), intent(in) :: db
    integer :: ierr

    if (check /= 0) then
        write(*,*) filename, line, checkstr, check
        call db%close(ierr)
        call abort
    endif
end subroutine

program test_sqlitef
    use sqlite_mod

    type(sqlite_db_t) :: db
    type(sqlite_stmt_t) :: stmt
    integer :: ierr
    integer :: r

    db = sqlite_open(":memory:", ierr)
    call assert_zero(ierr)

    stmt = db%prepare( &
        "create table test (foo int);", &
        ierr)
    call assert_zero(ierr)
    call stmt%step(ierr)
    call assert_zero(ierr - 101)
    call stmt%finalize(ierr)
    call assert_zero(ierr)

    stmt = db%prepare( &
        "insert into test (foo) values (5);", &
        ierr)
    call assert_zero(ierr)
    call stmt%step(ierr)
    call assert_zero(ierr - 101)
    call stmt%finalize(ierr)
    call assert_zero(ierr)

    stmt = db%prepare( &
        "select * from test;", &
        ierr)
    call assert_zero(ierr)
    call stmt%step(ierr)
    call assert_zero(ierr - 100)
    r = stmt%column_int(0)
    call assert_zero(r - 5)
    call stmt%finalize(ierr)
    call assert_zero(ierr)

    call db%close(ierr)
    call assert_zero(ierr)

end program
