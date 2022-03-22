
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
	palette 0, 0		' background: 0 black
	palette 8, 63 		' foreground: 0 white
	palette 9, 18 		'	      1 green
	palette 10, 25		'	      2 cyan
	palette 11, 54		'	      3 yellow

	' Clear screen
10	cls

	' Loading screen
	attr 3, 0 ' yellow
	print "*** DRAGONMAZE ***"
	print
	attr 0, 0 ' white

	print "by Rick Adams"
	print
	print "O ";
	attr 1, 0 ' green
	print "Player"

	attr 0, 0 ' white
	print "& ";
	attr 1, 0 ' green
	print "Dragon"

	attr 0, 0 ' white
	print "^ ";
	attr 1, 0 ' green
	print "Sword"

	attr 0, 0 ' white
	print "$ ";
	attr 1, 0 ' green
	print "Gold"

	print

	attr 2, 0 ' cyan
	print "* Use arrow keys to move."
	print "* Avoid the dragons."
	print "* Collect all the gold to win."
	print "* Collect swords to fight the dragons."
	print "* One sword will kill one dragon."
	print "* Swords magically vanish after use."
	print "* Good luck!"

	' Generate maze
	attr 1, 0 ' green
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
		attr 1, 0 ' green
		print str$(int(100 * (t - n) / t));
		print "%";
		goto 20
	end if

	' Draw maze
	cls
	attr 2, 0 ' cyan
	for i = 1 to mh * 2 + 1
		locate 0, i - 1
		print a$(i);
	next i

	' Place 10 gold pieces randomly in maze
	attr 0, 0 ' white
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
	attr 0, 0 ' white
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
	attr 1, 0 ' green

	' Init score
	s = 0
	locate 0, 23
	print "Gold: 0";

	' Init inventory
	i$ = ""
	locate 34, 23
	print "Swords: 0";

	' Init player
	x = 3
	y = 2
	locate x - 1, y - 1
	attr 0, 0 ' white
	print "O";

	' Place dragons in maze
	dim x(2), y(2), dx(2), dy(2)
	for i = 1 to 2
		read x(i), y(i), dx(i), dy(i)
		locate x(i) - 1, y(i) - 1
		attr 0, 0 ' white
		print "&";
	next i

	' Dragon data
	data 23, 12, 2, 0
	data 55, 12, -2, 0

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
		locate 41, 23
		attr 1, 0 ' green
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
		attr 0, 0 ' white
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

		' Check for player death before movement
		if x = x(i) and y = y(i) then
			gosub 7000 ' Player death
		end if

		' If dragon isn't dead, do dragon AI
		mx = x(i)
		my = y(i)
		if mx > 0 then
			gosub 8000 ' Dragon AI
		end if

		' Check for player death after movement
		if x = x(i) and y = y(i) then
			gosub 7000 ' Player death
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


	' Which direction(s) can the dragon go?
4000	r$ = ""

	' Up
	c$ = mid$(a$(my - 1), mx, 1)
	if instr("!+-", c$) = 0 then
		r$ = r$ + "1"
	end if

	' Down
	c$ = mid$(a$(my + 1), mx, 1)
	if instr("!+-", c$) = 0 then
		r$ = r$ + "2"
	end if

	' Left
	c$ = mid$(a$(my), mx - 2, 1)
	if instr("!+-", c$) = 0 then
		r$ = r$ + "3"
	end if

	' Right
	c$ = mid$(a$(my), mx + 2, 1)
	if instr("!+-", c$) = 0 then
		r$ = r$ + "4"
	end if

	return

	' Choose random direction for dragon to travel
4500	d = val(mid$(r$, rnd(len(r$)), 1))
	on d goto 4510, 4520, 4530, 4540

	' Up
4510	if len(r$) > 1 and dx(i) = 0 and dy(i) = 1 then
		goto 4500 ' Don't backtrack unless you have to
	end if
	dx(i) = 0
	dy(i) = -1
	goto 4550

	' Down
4520	if len(r$) > 1 and dx(i) = 0 and dy(i) = -1 then
		goto 4500 ' Don't backtrack unless you have to
	end if
	dx(i) = 0
	dy(i) = 1
	goto 4550

	' Left
4530	if len(r$) > 1 and dx(i) = 2 and dy(i) = 0 then
		goto 4500 ' Don't backtrack unless you have to
	end if
	dx(i) = -2
	dy(i) = 0
	goto 4550

	' Right
4540	if len(r$) > 1 and dx(i) = -2 and dy(i) = 0 then
		goto 4500 ' Don't backtrack unless you have to
	end if
	dx(i) = 2
	dy(i) = 0

	' Move the dragon that direction
4550	nx = mx + dx(i)
	ny = my + dy(i)
	return

	' Chase player
5000	p$ = ""
	if mx <> x and my <> y then

		' Not possible to see the player
		return

	end if

	' Direction to the player
	dx = 0
	dy = 0
	' Up
	if mx = x and my > y then
		p$ = "1"
		dy = -1
	end if
	' Down
	if mx = x and my < y then
		p$ = "2"
		dy = 1
	end if
	' Left
	if my = y and mx > x then
		p$ = "3"
		dx = -2
	end if
	' Right
	if my = y and mx < x then
		p$ = "4"
		dx = 2
	end if
	nx = mx
	ny = my

5010	nx = nx + dx
	ny = ny + dy
	c$ = mid$(a$(ny), nx, 1)
	if instr("!+-", c$) > 0 then

		' A wall prevents the dragon from seeing the player
		p$ = ""
		return

	end if
	if nx <> x or ny <> y then

		' Keep looking for the player
		goto 5010

	end if

	' Found the player, set movement to get closer
	r$ = p$
	dx(i) = dx
	dy(i) = dy
	return

	' Player collected all the gold
6000	m$ = "You've conquered the DragonMaze!"
	gosub 9000

	' Wait for keystroke, then restart the game
6010	s$ = inkey$
	if s$ = ""  then
		goto 6010
	end if

	' Ignore arrow keys so the player doesn't inadvertently restart the game too soon
	c = asc(s$)
	if c < 32 or c > 93 then
		goto 6010
	end if
	run

	' Player collided with a dragon
	' Is he holding a sword?
7000	locate x - 1, y - 1
	if len(i$) > 0 then

		' Take away the sword
		i$ = left$(i$, len(i$) - 1)
		locate 41, 23
		attr 1, 0 ' green
		print len(i$);

		' Kill the dragon (flash the screen white)
		x(i) = 0
		m$ = "Killed dragon"
		palette 0, 63 ' white
		gosub 9000

		' Player icon replaces dragon
		locate x - 1, y - 1
		attr 0, 0 ' white
		print "O";

		' Back to the game
		return

	end if

	' Dragon icon replaces player
	locate x - 1, y - 1
	attr 0, 0 ' white
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

	' Ignore arrow keys so the player doesn't inadvertently restart the game too soon
	c = asc(s$)
	if c < 32 or c > 93 then
		goto 7020
	end if
	run

	' Dragon AI
8000	nx = mx + dx(i)
	ny = my + dy(i)

	' Find all possible directions to move
	gosub 4000

	' Override those directions if player is visible
	gosub 5000

	' If we've hit a wall, or are at a junction, or are chasing player, choose a new direction
	c$ = mid$(a$(ny), nx, 1)
	if instr("!+-", c$) > 0 or len(r$) > 2 or len(p$) > 0 then
		gosub 4500
	end if

	' Move dragon
	x(i) = nx
	y(i) = ny
	locate mx - 1, my - 1

	' Display item behind dragon, if any
	attr 0, 0 ' white
	print mid$(a$(my), mx, 1);

	' Don't display dragon if he's collided with the player wielding the sword
	if i$ = "" or nx <> x or ny <> y then
		locate nx - 1, ny - 1
		print "&";
	end if

	' Chase player if visible from new location
	mx = x(i)
	my = y(i)
	gosub 5000

	return

9000	locate len(a$(1)) - len(m$), 23
	attr 1, 0 ' green
	print m$;
	palette 0, 0
	return
