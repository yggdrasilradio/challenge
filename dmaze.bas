
	' Double speed poke
	poke &hffd9, 0

	' Need a lot of string space
	clear 3000

	' Randomize the RND function
	x = rnd(-timer)

	' Reset machine on BREAK
	on brk goto 1000

	' Set up video mode and palette colors
	rgb
	width 80
	palette 0, 0		' background color
	for i = 8 to 15
		read c
		palette i, c	' 8 foreground colors
	next i

	' Palette color values:
	' yellow, red, green, blue, orange, cyan, magenta, white
	data 54, 36, 18, 11, 38, 25, 45, 63

	' Clear screen
10	cls

	' Loading screen
	attr 0, 0 ' yellow
	print "*** DRAGONMAZE ***"
	print
	attr 7, 0 ' white

	print "by Rick Adams"
	print
	print "O ";
	attr 2, 0 ' green
	print "Player"

	attr 7, 0 ' white
	print "& ";
	attr 2, 0 ' green
	print "Dragon"

	attr 7, 0 ' white
	print "^ ";
	attr 2, 0 ' green
	print "Sword"

	attr 7, 0 ' white
	print "$ ";
	attr 2, 0 ' green
	print "Gold"

	print

	attr 5, 0 ' cyan
	print "* Use arrow keys to move."
	print "* Avoid the dragons."
	print "* Collect all the gold to win."
	print "* A sword will kill one dragon."
	print "* Good luck!"

	' Generate maze
	attr 2, 0 ' green
	locate 0, 23
	print "Generating maze:";

	' Maze width and height
	mw = 19
	mh = 11
	t = mw * mh

	' Init maze
	dim a$(mh * 2 + 1)
	r1$ = "+"
	r2$ = "!"
	for i = 1 to mw
		r1$ = r1$ + "---+"
		r2$ = r2$ + " X !"
	next i
	for i = 1 to mh * 2 + 1
		if i and 1 then
			a$(i) =  r1$
		else
			a$(i) =  r2$
		end if
	next i

	' Visit first cell
	dim sx(mw * mh + 1), sy(mw * mh + 1)
 	s = 1
	n = mw * mh - 1
	sx(s) = 3
	sy(s) = 2
	mid$(a$(2), 3, 1) = " "

	' Find neighboring cells that haven't been visited that are behind walls
20	x = sx(s)
	y = sy(s)
	gosub 3000

	' No cells to choose from?
	if len(r$) = 0 then
		s = s - 1 ' pop the stack
		goto 20   ' try again
	end if

	' Choose cell at random and knock out the wall to that cell
	d = val(mid$(r$, rnd(len(r$)), 1))
	on d goto 22, 24, 26, 28

	' Up
22	y = y - 2
	mid$(a$(y + 1), x - 1, 3) = "   "
	goto 30

	' Down
24	y = y + 2
	mid$(a$(y - 1), x - 1, 3) = "   "
	goto 30

	' Left
26	x = x - 4
	mid$(a$(y), x + 2, 1) = " "
	goto 30

	' Right
28	x = x + 4
	mid$(a$(y), x - 2, 1) = " "

	' Push visited cell on stack
30	s = s + 1
	sx(s) = x
	sy(s) = y

	' Mark cell as visited
	mid$(a$(y), x, 1) = " "

	' Keep generating maze if not done
	n = n - 1
	if n > 0 then
		locate 16, 23
		attr 2, 0 ' green
		print str$(int(100 * (t - n) / t));
		print "%";
		goto 20
	end if

	' Draw maze
	cls
	attr 5, 0 ' cyan
	for i = 1 to mh * 2 + 1
		locate 0, i - 1
		print a$(i);
	next i

	' Place 10 gold pieces randomly in maze
	attr 7, 0 ' white
	for i = 1 to 10
40		x = rnd(mw)
		y = rnd(mh)
		if mid$(a$(y * 2), x * 4 - 1, 1) = " " then
			locate x * 4 - 2, y * 2 - 1
			print "$";
			mid$(a$(y * 2), x * 4 - 1, 1) = "$"
		else
			goto 40
		end if
	next i

	' Place 4 swords randomly in maze
	attr 7, 0 ' white
	for i = 1 to 4
50		x = rnd(mw)
		y = rnd(mh)
		if mid$(a$(y * 2), x * 4 - 1, 1) = " " then
			locate x * 4 - 2, y * 2 - 1
			print "^";
			mid$(a$(y * 2), x * 4 - 1, 1) = "^"
		else
			goto 50
		end if
	next i
	attr 2, 0 ' green

	' Init score
	s = 0
	locate 0, 23
	print "Gold: 0";

	' Init inventory
	i$ = ""
	locate 33, 23
	print "Swords: 0";

	' Init player
	x = 3
	y = 2
	locate x - 1, y - 1
	attr 7, 0 ' white
	print "O";

	' Place dragons in maze
	dim x(2), y(2), dx(2), dy(2)
	for i = 1 to 2
		read x(i), y(i), dx(i), dy(i)
		locate x(i) - 1, y(i) - 1
		attr 7, 0 ' white
		print "&";
	next i

	' Dragon data
	data 23, 2, 2, 0
	data 23, 14, -2, 0

	' Wait for key
100	s$ = inkey$
	if s$ = "" then
		goto 100
	end if

	' Erase status
	m$ = "                 "
	gosub 9000

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
		locate 0, 23
		print "Gold:"; s;
		mid$(a$(ny), nx, 1) = " "
		m$ = "Found gold"
		gosub 9000
	end if

	' Sword?
	if c$ = "^" then
		i$ = i$ + "^"
		locate 40, 23
		attr 2, 0 ' green
		print len(i$);
		mid$(a$(ny), nx, 1) = " "
		m$ = "Found sword"
		gosub 9000
	end if

	' Wall?
	if instr("!+-", c$) = 0 then

		' Move player
		locate x - 1, y - 1
		print " ";
		locate nx - 1, ny - 1
		attr 7, 0 ' white
		print "O";
		x = nx
		y = ny

	end if

	' Has the player won yet?
	if s = 100 then

		' Player collected all the gold
		gosub 6000

	end if

	' Update dragons
	gosub 2000

	' Keep going
	goto 100

	' Reset the machine
1000	poke &h71, 0
	exec &h8c1b

	' Update dragons
2000	for i = 1 to 2

		' Current position
		mx = x(i)
		my = y(i)

		' If dragon isn't dead, do dragon AI
		if mx > 0 then
			gosub 8000
		end if

		' Has player died?
		if x = x(i) and y = y(i) then
			gosub 7000
		end if

	next i
	return

	' Find all unvisited neighboring cells behind walls
3000	r$ = ""

	' Up
3010	if y = 2 then
		goto 3030
	end if
	ny = y - 2
	if mid$(a$(ny), x, 1) <> " " and mid$(a$(y - 1), x, 1) <> " " then
		r$ = r$ + "1"
	end if

	' Down
3030	if y = mh * 2 then
		goto 3040
	end if 
	ny = y + 2
	if mid$(a$(ny), x, 1) <> " " and mid$(a$(y + 1), x, 1) <> " " then
		r$ = r$ + "2"
	end if

	' Left
3040	if x = 3 then
		goto 3050
	end if
	nx = x - 4
	if mid$(a$(y), nx, 1) <> " " and mid$(a$(y), x - 2, 1) <> " " then
		r$ = r$ + "3"
	end if

	' Right
3050	if x = 4 * mw - 1 then
		goto 3060
	end if
	nx = x + 4
	if mid$(a$(y), nx, 1) <> " " and mid$(a$(y), x + 2, 1) <> " " then
		r$ = r$ + "4"
	end if

3060	return

	' Choose random direction for dragon to travel
4000	on rnd(4) goto 4010, 4020, 4030, 4040

	' Down
4010	dx(i) = 0
	dy(i) = 1
	goto 4050

	' Right
4020	dx(i) = 2
	dy(i) = 0
	goto 4050

	' Up
4030	dx(i) = 0
	dy(i) = -1
	goto 4050

	' Left
4040	dx(i) = -2
	dy(i) = 0

	' Can the dragon move there?
4050	nx = mx + dx(i)
	ny = my + dy(i)
	c$ = mid$(a$(ny), nx, 1)

	' Try again if not
	if instr("!+-", c$) > 0 then
		goto 4000
	end if

	return

	' Chase player
5000	if mx <> x and my <> y then

		' Not possible to see the player
		return

	end if

	' Direction to the player
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

		' A wall prevents the dragon from seeing the player
		return

	end if
	if nx <> x or ny <> y then

		' Keep looking for the player
		goto 5010

	end if

	' Found the player, set movement to get closer
	dx(i) = dx
	dy(i) = dy
	return

	' Player collected all the gold
6000	m$ = "You have conquered the DragonMaze!"
	gosub 9000

	' Wait for keystroke, then restart the game
6010	s$ = inkey$
	if s$ = "" then
		goto 6010
	end if
	run

	' Player collided with a dragon
	' Does he hold the sword?
7000	locate x - 1, y - 1
	if len(i$) > 0 then

		' Take away the sword
		i$ = left$(i$, len(i$) - 1)
		locate 40, 23
		attr 2, 0 ' green
		print len(i$);

		' Kill the dragon (flash the screen white)
		x(i) = 0
		m$ = "Killed dragon"
		palette 0, 63 ' white
		gosub 9000

		' Player icon replaces dragon
		locate x - 1, y - 1
		attr 7, 0 ' white
		print "O";

		' Back to the game
		return

	end if

	' Dragon icon replaces player
	locate x - 1, y - 1
	attr 7, 0 ' white
	print "&";

	' Aww, too bad, you lost (flash screen red)
	m$ = "You died"
	palette 0, 36
	gosub 9000

	' Wait for keystroke, then restart the game
7020	s$ = inkey$
	if s$ = "" then
		goto 7020
	end if
	run

	' Dragon AI
8000	nx = mx + dx(i)
	ny = my + dy(i)

	' If we've hit a wall, choose a new direction
	c$ = mid$(a$(ny), nx, 1)
	if instr("!+-", c$) > 0 then
		gosub 4000
	end if

	' Move dragon
	x(i) = nx
	y(i) = ny
	locate mx - 1, my - 1
	print mid$(a$(my), mx, 1);

	' Don't display dragon if he's collided with the player wielding the sword
	if i$ = "" or nx <> x or ny <> y then
		locate nx - 1, ny - 1
		attr 7, 0 ' white
		print "&";
	end if

	' Chase player if visible
	mx = x(i)
	my = y(i)
	gosub 5000

	return

9000	locate len(a$(1)) - len(m$), 23
	attr 2, 0 ' green
	print m$;
	palette 0, 0
	return
