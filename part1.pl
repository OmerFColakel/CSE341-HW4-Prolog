%	200104004043 Omer Faruk Colakel
%	CSE341 - Programming Languages - HW4 - Part 1

%room facts
%ID capacity projector smartboard handicapped

room(z01,30,1,0,0).
room(z02,10,0,0,0).
room(z03,13,0,0,1).
room(z04,15,1,0,1).
room(z05,30,0,1,1).

%course facts
%ID instructor capacity 

course(cse101,i1,5).
course(cse202,i2,10).
course(cse303,i3,15).
course(cse404,i4,15).
course(cse505,i5,25).

%instructor facts
% ID projector smartboard

instructor(i1,1,0).
instructor(i2,0,1).
instructor(i3,0,0).
instructor(i4,0,0).
instructor(i5,0,0).

%student facts
% ID handicapped

student(s1,0).
student(s2,1).
student(s3,1).
student(s4,0).
student(s5,0).
student(s6,0).
student(s7,0).
student(s8,0).
student(s9,1).
student(s10,1).

% occupancy facts
% roomID course hour

occupancy(z01,cse101,8).
occupancy(z01,cse101,9).
occupancy(z01,cse101,10).
occupancy(z01,cse101,11).

occupancy(z01,cse202,13).
occupancy(z01,cse202,14).
occupancy(z01,cse202,15).
occupancy(z01,cse202,16).

occupancy(z02,cse303,8).
occupancy(z02,cse303,9).
occupancy(z02,cse303,10).
occupancy(z02,cse303,11).

occupancy(z02,cse101,12).
occupancy(z02,cse101,13).
occupancy(z02,cse101,14).
occupancy(z02,cse101,15).

occupancy(z03,cse404,14).
occupancy(z03,cse404,15).
occupancy(z03,cse404,16).
occupancy(z03,cse404,17).

occupancy(z04,cse404,8).
occupancy(z04,cse404,9).
occupancy(z04,cse404,10).
occupancy(z04,cse404,11).

occupancy(z05,cse505,8).
occupancy(z05,cse505,9).
occupancy(z05,cse505,10).
occupancy(z05,cse505,11).
occupancy(z05,cse505,12).
occupancy(z05,cse505,13).
occupancy(z05,cse505,14).
occupancy(z05,cse505,15).
occupancy(z05,cse505,16).
occupancy(z05,cse505,17).


% student courses
% studentID courseID 

takingCourse(s1,cse101).
takingCourse(s1,cse202).
takingCourse(s1,cse303).
takingCourse(s2,cse101).
takingCourse(s2,cse202).
takingCourse(s2,cse303).

% Tests if there is a conflict between two courses. 
% If two diffrent courses occupies same room in the same hour returns true.
conflict(CourseID1,CourseID2) :- 
        occupancy(Room1,CourseID1,Hour1) ,
        occupancy(Room2,CourseID2,Hour2) ,
        Room1 == Room2 , Hour1 == Hour2,
        CourseID1 \= CourseID2,
        write('There is a conflict') .

% Test if there is a conflict in a room. If two diffrent courses are occupying at the same time returns true
conflict(RoomID) :-
                    occupancy(RoomID,CourseID1,Hour1),
                    occupancy(RoomID,CourseID2,Hour2),
                    CourseID1 \= CourseID2,             
                    Hour1 == Hour2,
                    write("There is a conflict")
                    .

% "assignable(cse101)." Tests if given course is assignable to which room. it checks capacities, instructor''s needs and student''s needs.
% "assignable(X)."      Checks which room can be assigned to which classes. it checks capacities, instructor''s needs and student''s needs.
assignable(CourseID) :- 
            room(RoomID, CapacityOfRoom, AvailableProj, AvailableSB, _),
            course(CourseID, InstructorID, CapacityOfCourse),
            instructor(InstructorID, WantProj, WantSB),
            aggregate_all(set(StudentID), takingCourse(StudentID, CourseID), AllStudents),
            is_handicapped_for_assignable(AllStudents, RoomID,1),
            CapacityOfCourse =< CapacityOfRoom,
            WantSB =< AvailableSB,
            WantProj =< AvailableProj,
            write(CourseID), write(" is assignable to "), write(RoomID)
            .

% Tests if given student can be enrolled to the given course.
enrollable(StudentID, CourseID) :-  
            \+takingCourse(StudentID,CourseID),                                     %checking if the student already taking that course
            course(CourseID, _, Capacity),                                          %taking a course
            aggregate_all(set(RoomID), occupancy(RoomID, CourseID, _), AllRooms),   %taking the list of rooms that was occupied with that course
            is_handicapped_for_enrollable(AllRooms,StudentID,1),                    %checking if the rooms are suited for a handicapped student
            aggregate_all(count, takingCourse(_, CourseID),Total),                  %taking number of students taking that course
            Total < Capacity                                                        %checking if the course is full
            .

is_handicapped_for_enrollable(AllRooms,StudentID,Index) :-  
    cthelement(RoomID, AllRooms, Index),
    room(RoomID, _, _, _, AvailableHC), 
    student(StudentID, IsHC),
    IsHC =< AvailableHC,
    NextIndex is Index +1,
    is_handicapped_for_enrollable(AllRooms,StudentID,NextIndex),
    \+length(AllRooms, Index)
    .

is_handicapped_for_enrollable(AllRooms,StudentID,Index) :- 
    cthelement(RoomID, AllRooms, Index),
    room(RoomID, _, _, _, AvailableHC), 
    student(StudentID, IsHC),
    IsHC =< AvailableHC,
    length(AllRooms, Index) 
    .

is_handicapped_for_assignable(AllStudents,RoomID,Index) :-  
    cthelement(StudentID, AllStudents, Index),
    room(RoomID, _, _, _, AvailableHC), 
    student(StudentID, IsHC),
    IsHC =< AvailableHC,
    NextIndex is Index +1,
    is_handicapped_for_assignable(AllStudents,RoomID,NextIndex),
    \+length(AllStudents, Index)
    .

is_handicapped_for_assignable(AllStudents,RoomID,Index) :- 
    cthelement(StudentID, AllStudents, Index),
    room(RoomID, _, _, _, AvailableHC), 
    student(StudentID, IsHC),
    IsHC =< AvailableHC,
    length(AllStudents, Index) 
    .

% these two returns the C. element of a list
cthelement(A,[A|_],1).
cthelement(A,[_|B],C) :- C > 1, D is C - 1, cthelement(A,B,D).
