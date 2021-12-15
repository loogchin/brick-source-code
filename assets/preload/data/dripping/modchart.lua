function update(elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
        if curStep > 256 and curStep < 635 then
            for i=0,7 do
                setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
                setActorY(_G['defaultStrum'..i..'Y'] + 10,i)
            end
        end
        if curStep > 766 and curStep < 1148 then
            for i=0,7 do
                setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
                setActorY(_G['defaultStrum'..i..'Y'] + 10,i)
            end
        end
        if curStep > 1282 and curstep < 1411 then
            for i=0,7 do
                setActorX(_G['defaultStrum'..i..'X'] + 64 * math.sin((currentBeat + i*0) * math.pi), i)
                setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.cos((currentBeat + i*5) * math.pi) + 10 ,i)
            end
        end
    end