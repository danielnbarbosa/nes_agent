# Summary


Using reinforcement learning to beat old NES games.  Uses [sample-factory](https://github.com/danielnbarbosa/sample-factory) and [stable-retro](https://github.com/danielnbarbosa/stable-retro).



# Games


### Kung Fu
Model was trained for 600 million frames after which it can beat the game 7 times over.  [Reward function](https://github.com/danielnbarbosa/stable-retro/blob/master/retro/data/stable/KungFu-Nes/script.lua) is pretty generic.


### Double Dragon
Model was trained for around 1.2 billion frames.  Can get halfway through Mission 3.  After that I gave up as the [reward function](https://github.com/danielnbarbosa/stable-retro/blob/master/retro/data/stable/DoubleDragon-Nes/script.lua) was getting ridiculously hacky.


### Super Mario Bros

Model was trained for 4 billion frames.  Evaluation is done using a single model and a single reward function with 3 lives.  It was necessary to use some hacky hand guidance in the [reward function](https://github.com/danielnbarbosa/stable-retro/blob/master/retro/data/stable/SuperMarioBros-Nes/script.lua), especially on the castle maze levels (4-4, 7-4 and 8-4).  Definitely room for improvement here.  Watch the [video](https://www.youtube.com/watch?v=dbUaV5uOli8).





# Gory details

This repo represents my work applying RL to old NES games.  I figured Atari games have already been beaten to death.  Then there is also the large nostalgia factor I have with NES games having grown up with them.

My ultimate goal was to train a single model that could beat the entire Super Mario Bros game using only 3 lives.  I don’t think this has ever been done before.  At least I couldn’t find anything in github or arxiv.

I decided this time I wouldn’t write yet another buggy PPO implementation of my own and would find a decent library to use.  I played around with various PPO implementations like stable baselines and cleanRL and while they have their merits I ultimately settled on sample-factory.  This is an asyncronous PPO implementation that blows the competion out of the water.   I would get about 80,000 FPS training on a single machine VS the 2,000 - 4,000 FPS I would get with the competion.

The other library that I leveraged heavily was stable-retro.  This is also a fantastic piece of software that provides a gymnasium interface to old console games.  You have to procure the ROMs yourself but then its quite easy to integrate.  It also provides a game integration UI that allows you to find values from the game’s RAM that you want to use in your reward function.

Once I had these two things glued together I had everything I needed to start training models on some NES games.

After some initial testing on my M1 mac I started looking for sould cheap cloud GPUs to use.  At first I used Lambda Labs which was fine but they were often out of capacity so it got be looking around.  Then I stumbed on vast.ai which allows people to rent out their GPUs to people that want to use them.  I wouldn’t trust it with anything sensitive put for Super Mario Bros it seemed fine.  Prices are much cheaper than Lambda Labs but the real kicker is that there are machines with crazy amounts of CPU cores.  Turns out this is what really drove training performance as it is  the game emulation that was the bottleneck.  GPU hardly made any difference, the more CPU cores I could get the better.  My favorite machine was an RTX 3060 with 384 CPU cores.

I figured before tackling Mario I should start with something easier so I settled on Kung Fu.  This is a relatively short game with simple mechanics.  It was a good place to cut my teeth.  I learned how to get interesting values out of game RAM and use them in my reward function.  Much of the work then was tweaking the reward function.   Just moving forward is often not enough but then as I added more things I would constantly be surprised by how the the agent would find ways to exploit them and do some inane form of reward harvesting.  The moral of the story is make the reward function as simple as you can.  Ultimately I was able to train a model that could beat the game 7 times over.

I was still scared of trying Super Mario Bros so next I did Double Dragon.  In retrospect I think this was a bad idea.  In many ways it is more complicated than Mario.  You have more degrees of freedom of movement.  Progress is not always in the same direction, sometimes you have to go up or down too.  There are some areas where the game loops if you take the wrong path, though Mario has these as well.  Ultimately I was able to make it about halfway through the game before the reward function became so gnarly that I threw my hands up in disgust.

Finally I was ready to tackle Super Mario Bros.  The game has 32 stages.  I figured as a first step I would see if I could pass each stage individually.  I decided to skip the castle levels with looping mazes for now, these would be 4-4, 7-4 and 8-4.  I discovered some other difficult stages in the process, notably the air stages 1-3, 4-3 and 5-3.  These are on platforms where Mario would often get stuck doing big jumps into air instead of making forward progress.  The other problem stages were the underwater ones, 2-2 and 7-2.  These present a very different mechanic and Mario also had trouble finding the horizontal exit pipe.  He would often stay right on top of it trying to move right.

The most important part of the reward function is moving right.  This gives it a dense reward signal that works well throughout the game.  There is also a large reward for finishing a stage which seems to help.  I ended up adding a reward for  entering horizontal pipes which I think minimized the amount of time being stuck at the end of 2-2 and 7-2, and even 1-2.  I also had to prevent restarting from a checkpoint on the air levels 1-3, 4-3 and 5-3 as Mario would never be able to make any progress from there, instead he would always start at the begining of the stage.  Then of course I had to add some custom handholding for the castle maze levels 4-4, 7-4 and 8-4.  These must be navigated in a specific order or else they loop and you repeat the same section.  This is crack cocaine for an agent rewarded for going right so it cannot be allowed.  These are arguable the mosty hacky parts of the reward function.

I think it is possible to clean up a lot of these reward function hacks and I did make some progress on that front but I wasn’t able to get a model that could solve the entire game.

Ultimately I was able to train a model that could finish the entire game using 3 lives.  This was after 16 hours of training or about 4 billion game frames.  And it could only occasionally finish the game with just 3 lives.  But it could do it.

It definitely looks like a very competent speed runner, deftly making very precise moves.  It even does this crazy jump up to the high pipe in World 8-4 that I didn’t even know was possible.  However my suspicion is that it is mostly learning the sequence of moves and not really learning how to play.  If you were to give it a new level it hadn’t seen before it would probably do terribly.