local xx = 200
local yy = 470
local xx2 = 200
local yy2 = 470
local ofs = 50
local followchars = true

-- uncanny version

function onCreate()	
	makeLuaSprite('sky', 'trippinballs/abstract/abstractbg', -600, -300);
	scaleObject('sky', 1.3, 1.3);
	setScrollFactor('sky', 0.3, 0.3);
	
	makeLuaSprite('ground', 'trippinballs/abstract/abstractground', -600, -300);
	scaleObject('ground', 1.3, 1.3);
	
	makeLuaSprite('over0', 'trippinballs/abstract/overlay', -800, -500);
	scaleObject('over0', 1.5, 1.5);
	setBlendMode('over0', 'overlay');
	setScrollFactor('over0', 0.9, 0.9);
	setProperty('over0.alpha', 0.1);
	makeLuaSprite('over1', 'trippinballs/abstract/multiplyblend', -800, -500);
	scaleObject('over1', 1.5, 1.5);
	setBlendMode('over1', 'multiply');
	makeLuaSprite('over2', 'trippinballs/abstract/addblend', -800, -500);
	scaleObject('over2', 1.5, 1.5);
	setBlendMode('over2', 'add');
	
	makeLuaSprite('bartop', nil, -100, 800);
	makeLuaSprite('barbot', nil, -100, -115);
	makeGraphic('bartop', 1400, 100, '000000');
	makeGraphic('barbot', 1400, 100, '000000');
	setObjectCamera('bartop', 'hud');
	setObjectCamera('barbot', 'hud');
	setProperty('bartop.angle',2);
	setProperty('barbot.angle',2);

	addLuaSprite('sky', false);
	addLuaSprite('ground', false);
	addLuaSprite('over1', true);
	addLuaSprite('over2', true);
	addLuaSprite('over0', true);
	addLuaSprite('bartop', false);
	addLuaSprite('barbot', false);
	
	--close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

function onCreatePost()
	setProperty("gf.visible", false)
	setProperty("boyfriend.visible", false)
	setProperty("camHUD.alpha", 0)
end

function onCountdownStarted()
	--change da strums to be uncanny valley esque
	setPropertyFromGroup('playerStrums', 0, 'x', 115);
	setPropertyFromGroup('playerStrums', 1, 'x', 265);
	setPropertyFromGroup('playerStrums', 2, 'x', 905);
	setPropertyFromGroup('playerStrums', 3, 'x', 1055);
	
	for i = 0, 3 do
		setPropertyFromGroup('opponentStrums', i, 'x', -900);
	end
end

function onEvent(name, value1, value2)
	if name == "HUD Alpha" then
		doTweenY('b1', 'bartop', 650, 0.7, 'quadIn');
		doTweenY('b2', 'barbot', -30, 0.7, 'quadIn');
	end
end

function onUpdate(elapsed)
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