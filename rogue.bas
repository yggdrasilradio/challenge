
	' Reset machine on BREAK
	on brk goto 1000

	' Clear screen
	cls

	' Init maze
	dim a$(15)
	for i = 1 to 15
		read d$
		a$(i) = d$
		print d$
	next i

	' Maze data
	data "+-------------------+-------+"
	data "!                   !       !"
	data "+---+   +-------+   +---+   !"
	data "!   !         ^ !           !"
	data "!   +   +---+---+   +-------+"
	data "!           !               !"
	data "!   +---+   !   +-----------+"
	data "! $ !       !   !           !"
	data "+---+   +---+   +-------+   !"
	data "!       !   !               !"
	data "+---+   !   +---+   +-------+"
	data "! $ !   !     $ !           !"
	data "!   +   +   +---+-------+   !"
	data "!                 $     ! $ !"
	data "+-----------------------+---+"

	' Init score
	s = 0
	p = 15 * 32
	print @p, "GOLD: 0";

	' Init player
	x = 3
	y = 2
	p = (y - 1) * 32 + x - 1
	print @p, "O";

	' Init monsters
	dim x(2), y(2), dx(2), dy(2)
	for i = 1 to 2
		read x(i), y(i), dx(i), dy(i)
	next i
	gosub 3000

	' Monster data
	data 23, 2, 2, 0
	data 23, 14, -2, 0

	' Wait for key
20	s$ = inkey$
	if s$ = "" then
		goto 20
	end if

	' Execute keyboard command
	i = asc(s$)
	nx = x
	ny = y
	if i = 94 then		' uparrow
		ny = ny - 1
	end if
	if i = 10 then		' downarrow
		ny = ny + 1
	end if
	if i = 8 then		' leftarrow
		nx = nx - 2
	end if
	if i = 9  then		' rightarrow
		nx = nx + 2
	end if

	' Check for collision
	c$ = mid$(a$(ny), nx, 1)

	' Gold?
	if c$ = "$" then
		s = s + 10
		p = 15 * 32
		print @p, "GOLD:"; s;
		mid$(a$(ny), nx, 1) = " "
	end if

	' Sword?
	if c$ = "^" then
		mid$(a$(ny), nx, 1) = " "
	end if

	' Wall?
	if instr("!+-", c$) = 0 then

		' Move player
		p = (y - 1) * 32 + x - 1
		print @p, " ";
		p = (ny - 1) * 32 + nx - 1
		print @p, "O";
		x = nx
		y = ny

	end if

	' Move monsters
	gosub 2000

	' Keep going
	goto 20

	' Reset the machine
1000	poke &h71, 0
	exec &h8c1b

	' Move monsters
2000	for i = 1 to 2
		mx = x(i)
		my = y(i)

		' Seek player
		gosub 5000

		nx = mx + dx(i)
		ny = my + dy(i)

		' If we've hit a wall, choose a new direction
		c$ = mid$(a$(ny), nx, 1)
		if instr("!+-", c$) > 0 then
			gosub 4000
		end if

		x(i) = nx
		y(i) = ny
		p = (my - 1) * 32 + mx - 1
		p2 = (ny - 1) * 32 + nx - 1
		print @p, mid$(a$(my), mx, 1);
		print @p2, "&";

	next i
	return

	' Render monsters
3000	for i = 1 to 2
		p = (y(i) - 1) * 32 + x(i) - 1
		print @p, "&";
	next i
	return

	' Choose direction for monster to travel
4000	on rnd(4) goto 4010, 4020, 4030, 4040
4010	dx(i) = 0
	dy(i) = 1
	goto 4050
4020	dx(i) = 2
	dy(i) = 0
	goto 4050
4030	dx(i) = 0
	dy(i) = -1
	goto 4050
4040	dx(i) = -2
	dy(i) = 0
	goto 4050
4050	nx = mx + dx(i)
	ny = my + dy(i)
	c$ = mid$(a$(ny), nx, 1)
	if instr("!+-", c$) > 0 then
		goto 4000
	end if
	return

	' Seek player
5000	if mx <> x and my <> y then
		return
	end if
	dx = 0
	dy = 0
	if mx = x and my < y then
		dy = 1
	end if
	if mx = x and my > y then
		dy = -1
	end if
	if my = y and mx < x then
		dx = 2
	end if
	if my = y and mx > x then
		dx = -2
	end if
	nx = mx
	ny = my
5010	nx = nx + dx
	ny = ny + dy
	c$ = mid$(a$(ny), nx, 1)
	if instr("!+-", c$) > 0 then
		return
	end if
	if nx <> x or ny <> y then
		goto 5010
	end if
	dx(i) = dx
	dy(i) = dy
	return
