function onCreate()
	precacheImage(star/Space)
	precacheImage(star/NOTE_assetsSTAR)
	precacheImage(star/bg)
	precacheImage(star/god_bg)
end

function onStepHit()
        if curStep == 616 then
            for i = 0, getProperty('unspawnNotes.length')-1 do
                setPropertyFromGroup('unspawnNotes', i, 'texture', 'star/NOTE_assetsSTAR');
       	    end
        end
	if curStep == 631 then
	    for i = 0,7 do
                setPropertyFromGroup('strumLineNotes', i, 'texture','star/NOTE_assetsSTAR')
            end
        end
end