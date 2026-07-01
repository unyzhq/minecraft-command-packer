execute as @s[type=minecraft:player] at @s run summon minecraft:marker ~ ~ ~ {Tags:["pc.raycast","pc.init"]}
execute as @s[type=minecraft:player] at @s anchored eyes run tp @e[type=minecraft:marker,tag=pc.raycast,tag=pc.init,limit=1] ^ ^ ^0.5 ~ ~
execute as @s[type=minecraft:player] run scoreboard players set @e[type=minecraft:marker,tag=pc.raycast,tag=pc.init] pc.val 50
execute as @s[type=minecraft:player] run tag @e[type=minecraft:marker,tag=pc.raycast,tag=pc.init] remove pc.init

execute as @e[type=minecraft:marker,tag=pc.raycast] at @s if block ~ ~ ~ minecraft:air run tag @s add pc.air
execute as @e[type=minecraft:marker,tag=pc.raycast] at @s if block ~ ~ ~ minecraft:cave_air run tag @s add pc.air
execute as @e[type=minecraft:marker,tag=pc.raycast] at @s if block ~ ~ ~ minecraft:void_air run tag @s add pc.air

execute as @e[type=minecraft:marker,tag=pc.raycast,tag=!pc.air] at @s align xyz positioned ~0.5 ~-0.05 ~0.5 run execute as @e[type=minecraft:interaction,tag=pc.raycast_block_shield,distance=..0.01] run scoreboard players set @s pc.val 2

execute as @e[type=minecraft:marker,tag=pc.raycast,tag=!pc.air] at @s if data block ~ ~ ~ Command align xyz positioned ~0.5 ~-0.05 ~0.5 unless entity @e[type=minecraft:interaction,tag=pc.raycast_block_shield,distance=..0.01] run summon minecraft:interaction ~ ~ ~ {width:1.09f,height:1.09f,Tags:["pc.raycast_block_shield","pc.init"]}
execute as @e[type=minecraft:marker,tag=pc.raycast,tag=!pc.air] at @s if block ~ ~ ~ minecraft:decorated_pot align xyz positioned ~0.5 ~-0.05 ~0.5 unless entity @e[type=minecraft:interaction,tag=pc.raycast_block_shield,distance=..0.01] run summon minecraft:interaction ~ ~ ~ {width:1.09f,height:1.09f,Tags:["pc.raycast_block_shield","pc.init"]}

execute as @e[type=minecraft:interaction,tag=pc.raycast_block_shield,tag=pc.init] run scoreboard players set @s pc.val 2
execute as @e[type=minecraft:interaction,tag=pc.raycast_block_shield,tag=pc.init] run tag @s remove pc.init

execute as @e[type=minecraft:marker,tag=pc.raycast,tag=!pc.air] run kill @s

execute as @e[type=minecraft:marker,tag=pc.raycast,tag=pc.air] run tag @s remove pc.air

execute as @e[type=minecraft:interaction,tag=pc.raycast_block_shield] if score @s pc.val matches 1.. run scoreboard players remove @s pc.val 1

execute as @e[type=minecraft:marker,tag=pc.raycast] at @s unless score @s pc.val matches 0 run tp @s ^ ^ ^0.1
execute as @e[type=minecraft:marker,tag=pc.raycast] at @s unless score @s pc.val matches 0 run scoreboard players remove @s pc.val 1
execute as @e[type=minecraft:marker,tag=pc.raycast] if score @s pc.val matches 0 run kill @s
execute as @e[type=minecraft:marker,tag=pc.raycast,limit=1] run function command_packer_core:raycast