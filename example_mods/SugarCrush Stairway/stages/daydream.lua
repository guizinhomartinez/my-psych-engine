local xx = 500
local yy = 400
local xx2 = 800
local yy2 = 350
local ofs = 50
local followchars = true


function onCreate()
	makeLuaSprite('sky', 'trippinballs/dream/daydreamsky', -600, -300);
	scaleObject('sky', 1.3, 1.3);
	setScrollFactor('sky', 0.9, 0.9);
	
	makeLuaSprite('ground', 'trippinballs/dream/daydreamground', -600, -300);
	scaleObject('ground', 1.3, 1.3);
	
	makeLuaSprite('over0', 'trippinballs/dream/overlay', -600, -300);
	scaleObject('over0', 1.3, 1.3);
	setBlendMode('over0', 'overlay');
	setScrollFactor('over0', 0.9, 0.9);
	setProperty('over0.alpha', 0.1);
	makeLuaSprite('over1', 'trippinballs/dream/multiplyblend', -600, -300);
	scaleObject('over1', 1.3, 1.3);
	setBlendMode('over1', 'multiply');
	makeLuaSprite('over2', 'trippinballs/dream/addblend', -600, -300);
	scaleObject('over2', 1.3, 1.3);
	setBlendMode('over2', 'add');
	setScrollFactor('over2', 0.9, 0.9);
	
	makeLuaSprite('bartop', nil, 0, -30);
	makeLuaSprite('barbot', nil, 0, 650);
	makeGraphic('bartop', screenWidth, 100, '000000');
	makeGraphic('barbot', screenWidth, 100, '000000');
	setObjectCamera('bartop', 'hud');
	setObjectCamera('barbot', 'hud');

	addLuaSprite('ground', false);
	addLuaSprite('sky', false);
	addLuaSprite('over0', true);
	addLuaSprite('over1', false);
	addLuaSprite('over2', false);
	addLuaSprite('bartop', false);
	addLuaSprite('barbot', false);
	
	--close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

function onCreatePost()
	setProperty("gf.visible", false)
end

function onUpdate(elapsed)
	if curStep >= 0 then

		songPos = getSongPosition()

		local currentBeat = (songPos/1000)*(bpm/80)

		doTweenY('bwop', 'boyfriend', -30+50*math.sin((currentBeat*0.25)*math.pi),0.01)

  end
	if mustHitSection == false then
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
        else
			setProperty('defaultCamZoom',0.6)
            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx2,yy2)
            end
      end	
end