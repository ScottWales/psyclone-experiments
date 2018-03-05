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

module field_set_mod
    implicit none
    private
    public field_set_t

    type :: field_t

    end type

    type :: field_set_t
        type(field_t), allocatable :: fields(:)
        integer :: set_id = -1

    end type

contains
    
    ! Initialise the database tables
    subroutine init(db)
        use sqlite_mod
        type(sqlite_db_t), intent(in) :: db
        type(sqlite_stmt_t) :: stmt
        integer :: ierr

        ! DB table to match a field_set's fields with its attributes
        stmt = db%prepare(&
            "create table field_set( " //&
                "id INTEGER PRIMARY KEY)", &
            ierr)
        stmt = db%prepare(&
            "create table field_set_fields( " //&
                "id INTEGER PRIMARY KEY," //&
                "set_id INTEGER," //&
                "field_id INTEGER," //&
                "name TEXT," //&
                "standard_name TEXT," //&
                "units TEXT," //&
                "FORIEGN KEY set_id REFERENCES field_set(id)," //&
                "UNIQUE(set_id, field_id))", &
            ierr)
        call stmt%step(ierr)
        call stmt%finalize(ierr)

    end subroutine

    function field_set() result(r)
        type(field_set_t) :: r


    end function

end module
