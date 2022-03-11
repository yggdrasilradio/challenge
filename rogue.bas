
	' Reset machine on BREAK
	on brk goto 1000

	' Clear screen
10	cls

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

	' Init snakes
	dim x(2), y(2), dx(2), dy(2)
	for i = 1 to 2
		read x(i), y(i), dx(i), dy(i)
	next i
	for i = 1 to 2
		p = (y(i) - 1) * 32 + x(i) - 1
		print @p, "&";
	next i

	' Monster data
	data 23, 2, 2, 0
	data 23, 14, -2, 0

	' Init inventory
	i$ = ""

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
		i$ = "^"
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

	' Has the player won yet?
	if s = 50 then
		gosub 6000
	end if

	' Update snakes
	gosub 2000

	' Keep going
	goto 20

	' Reset the machine
1000	poke &h71, 0
	exec &h8c1b

	' Update snakes
2000	for i = 1 to 2

		' Current position
		mx = x(i)
		my = y(i)

		' If snake isn't dead, do snake AI
		if mx > 0 then
			gosub 8000
		end if

		' Has player died?
		if x = x(i) and y = y(i) then
			gosub 7000
		end if

	next i
	return

	' Choose random direction for snake to travel
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
4050	nx = mx + dx(i)
	ny = my + dy(i)
	c$ = mid$(a$(ny), nx, 1)
	if instr("!+-", c$) > 0 then
		goto 4000
	end if
	return

	' Chase player
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

	' Player collected all the gold
6000	p = 15 * 32 + 16
	print @p, "YOU HAVE WON!";
6020	s$ = inkey$
	if s$ = "" then
		goto 6020
	end if
	run

	' Player collided with a snake
	' Does he hold the sword?
7000	p = (y - 1) * 32 + x - 1
	if i$ = "^" then

		' Take away the sword
		i$ = ""

		' Kill the snake
		x(i) = 0

		' Player icon replaces snake
		print @p, "O";

		' Back to the game
		return

	end if

	' Snake icon replaces player
	print @p, "&";

	' Aww, too bad, he lost
	p = 15 * 32 + 21
	print @p, "YOU DIED";
7020	s$ = inkey$
	if s$ = "" then
		goto 7020
	end if
	run

	' Monster AI
8000	nx = mx + dx(i)
	ny = my + dy(i)

	' If we've hit a wall, choose a new direction
	c$ = mid$(a$(ny), nx, 1)
	if instr("!+-", c$) > 0 then
		gosub 4000
	end if

	' Move snake
	x(i) = nx
	y(i) = ny
	p = (my - 1) * 32 + mx - 1
	p2 = (ny - 1) * 32 + nx - 1
	print @p, mid$(a$(my), mx, 1);

	' Don't display snake if he's collided with the player wielding the sword
	if i$ = "" or nx <> x or ny <> y then
		print @p2, "&";
	end if

	' Chase player
	mx = x(i)
	my = y(i)
	gosub 5000

	return
