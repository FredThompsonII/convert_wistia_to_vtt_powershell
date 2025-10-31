Use this at your own risk. If you have any problems or cause any damage, that's YOUR responsibility.

This is an example of pure vibecoding with claude.ai

It's a Quick-and-Dirty routine made for my specific needs and practices.

I had a few thousand Wistia mp4 and subtitle .json files. The goal was to convert the subtitles to vtt format and mux each pair into an mkv file.

I've already hand-built a number of routines like this for operations I do frequently.
IMNSO, I prefer to leverage small, simple, tested, existing tools to reach the desired results.
As much as I like programming, the syntax and minutia get in the way of the bigger goal which is functional, profitable (time use) tools for specialized needs.

I'd been testing ChatGPT for vibecoding. It stinks.
Claude.ai has a good reputation so I tried it. It's pretty nice, actually.

This particular tool is quite simple and I could have created it entirely by hand but why create extra work and mental cost if it can be vibecoded?

I thought, at best, claude.ai would give me a basic framework and I'd have to debug and hand-code parts.

It turns out, claude.ai created the whole thing!

I've added the way I've integrated this into Windows' file manager context menu.
Right-click on a folder's contents and a sub-menu titled, "All Files" is present. Inside that is the option to run this conversion.

folder json to vtt powershell.bat and convert_wistia_to_vtt_powershell.bat must be in folder "C:\Portable\- Linked\misc"
Closed Caption Icon.ico must be in folder "C:\Portable\- Linked\Graphics\Icons"
Context Menu - Configure.reg creates the context menu entry - BE CAREFUL! it's just there as an example. If you already have a sub-menu titled "All Files", this reg file will replace it.

You can also place convert_wistia_to_vtt_powershell.bat in the folder which contains Wistia .json subtitle file then run it.

BE CAREFUL! This routine assumes all .json files are Wista .json subtitle files.
