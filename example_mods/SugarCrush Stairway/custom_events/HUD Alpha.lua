--this is dumb LOL
alpha = 1
speed = 1

function onEvent(n,v1,v2)
	if n == "HUD Alpha" then

	alpha = tonumber(v1)
	speed = tonumber(v2)
	
	doTweenAlpha('hudFunne', 'camHUD', alpha, speed, 'linear')
	end
end