require("model2")

function Init()

	TestSurface = Video_CreateSurfaceFromFile("scripts\\scanlines_default.png");
	wide=true
	press=0
end

function Frame()
		if Input_IsKeyPressed(0x3F)==1 and press==0 then wide=not wide press=1
		elseif Input_IsKeyPressed(0x3F)==0 and press==1 then press=0
		end
		
	if wide==true then
		Model2_SetStretchAHigh(0)
	 	Model2_SetStretchALow(0)
		Model2_SetStretchBHigh(0)
	 	Model2_SetStretchBLow(0)
		Model2_SetWideScreen(0)
	else
		Model2_SetStretchAHigh(0)
	 	Model2_SetStretchALow(0)
		Model2_SetStretchBHigh(0)
	 	Model2_SetStretchBLow(0)
		Model2_SetWideScreen(0)
	end
end

function PostDraw()
		if Options.scanlines.value==1 then
		Video_DrawSurface(TestSurface,0,0);
	end

end

function timecheatfunc(value)
        I960_WriteWord(RAMBASE+0x6E0A8,99*60); -- 99 seconds always
end

function maxpointsfunc(value)
        I960_WriteWord(RAMBASE+0xC6D58,9999); -- max points
end

Options =
{
	timecheat={name="Infinite Time",values={"Off","On"},runfunc=timecheatfunc},
	maxpoints={name="Max Points",values={"Off","On"},runfunc=maxpointsfunc},
	scanlines={name="Scanlines (50%)",values={"Off","On"}}
}
