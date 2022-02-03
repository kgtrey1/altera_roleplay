# ALTERA

A framework for FiveM that i didn't finished.

The server is launched using docker and the code is mainly written in LUA.

Features:
- Register as a citizen on the game
- Own licenses such as firearms or driving
- Own enterprise. There are multiple jobs, usually, there is only one enterprise by job, but I feeled that the need of having multiple enterprises for the same job was really important.
- Vehicle management (such as keys, you can trade keys from your vehicle and the player model animate using keys).
- Banking system. Player can chose a bank and bank were supposed to be run by players.
- Outlaw system: Outlaws are able to launch missions to get guns and have a private chest they can use. They have to find Lester to do so, because again, outlaws are usually controlled by admins and I think admins should not interfere with the game.
- Inventory system based on weight.
- Shop system where the player can buy items

I tried to optimize every thread, position checks are in function of where the player stand. If he's far from the action point, there the checks will be less frequent. If he's near, then the threads will make checks every 1ms like other FiveM framework and mods (which are in my opinion, poorly optimized on that point).

I would like to thank the work of all the people who shared repositories that I forked and then modified for my own use.

## Contributing
Pull requests are welcome. Even if I don't think I will keep working on this project.

## License
[MIT](https://choosealicense.com/licenses/mit/)
