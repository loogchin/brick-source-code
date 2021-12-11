local funnywindow = false
local NOMOREFUNNY = false

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
    if funnywindow then
        setWindowPos(24 * math.sin(currentBeat * math.pi) + 327, 24 * math.sin(currentBeat * 3) + 160)
    end
    if NOMOREFUNNY then
        setWindowPos(0 * math.sin(currentBeat * math.pi) + 327, 0 * math.sin(currentBeat * 3) + 160)
    end
end
-- fixed the step they start at BECAUSE CYBER'S A IDIOT AND OFFSET ALL OF THEM
function stepHit(step)
    if curStep == 256 then
        funnywindow = true
	end
	if curStep == 635 then
        funnywindow = false
        NOMOREFUNNY = true
	end
    if curstep == 767 then
        NOMOREFUNNY = false
        funnywindow = true
    end
    if curStep == 1152 then
        funnywindow = false
        NOMOREFUNNY = true
	end
end