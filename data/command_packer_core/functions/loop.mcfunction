# 萝卜&陶罐 方块选中
execute as @a at @s if data entity @s SelectedItem{id:"minecraft:wooden_sword",tag:{pc_command_packer:1b}} run function command_packer_core:raycast
execute as @a[nbt={SelectedItem:{id:"minecraft:wooden_sword",tag:{pc_command_packer:1b}}},nbt={Inventory:[{Slot:-106b,id:"minecraft:emerald"}]}] run gamemode creative @s
execute as @a unless entity @s[nbt={SelectedItem:{id:"minecraft:wooden_sword",tag:{pc_command_packer:1b}}}] unless entity @s[nbt={Inventory:[{Slot:-106b,id:"minecraft:wooden_sword",tag:{pc_command_packer:1b}}]}] run gamemode survival @s
execute as @e[type=minecraft:item,nbt={Item:{id:"minecraft:wooden_sword",tag:{pc_command_packer:1b}}},limit=1] run tag @s add pc.command_packer_droped
execute as @e[type=minecraft:item,nbt={Item:{id:"minecraft:wooden_sword",tag:{pc_command_packer:1b}}},limit=1] on owner at @s run tp @e[type=minecraft:item,tag=pc.command_packer_droped,nbt={Item:{id:"minecraft:wooden_sword",tag:{pc_command_packer:1b}}},limit=1] @s
execute as @e[type=minecraft:item,tag=pc.command_packer_droped,nbt={Item:{id:"minecraft:wooden_sword",tag:{pc_command_packer:1b}}},limit=1] run data merge entity @s {PickupDelay:0s}
execute as @e[type=minecraft:item,tag=pc.command_packer_droped,nbt={Item:{id:"minecraft:wooden_sword",tag:{pc_command_packer:1b}}},limit=1] run tag @s remove pc.command_packer_droped


# 移除选中
execute as @e[type=minecraft:interaction,tag=pc.raycast_block_shield] if score @s pc.val matches ..0 run kill @s
execute as @e[type=minecraft:interaction,tag=pc.raycast_block_shield] if score @s pc.val matches 1.. run scoreboard players remove @s pc.val 1

execute at @e[type=minecraft:item_display,tag=pc.emerald,tag=!pc.price_locked] positioned ~ ~-1.22 ~ as @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,nbt={interaction:{}},distance=..0.5,limit=1] run tag @s add pc.origin_clicked_interaction
execute as @e[type=minecraft:interaction,tag=pc.origin_clicked_interaction] at @s positioned ~ ~1.22 ~ if entity @e[type=minecraft:item_display,tag=pc.emerald,distance=..0.5] run tag @s add pc.clicked_interaction
execute as @e[tag=pc.clicked_interaction] on target if data entity @s SelectedItem{id:"minecraft:emerald"} run tag @s add pc.emerald_in_hand
execute as @e[tag=pc.clicked_interaction] run execute as @a[tag=pc.emerald_in_hand] at @s run playsound minecraft:ui.button.click music @s
execute as @e[tag=pc.clicked_interaction] if entity @a[tag=pc.emerald_in_hand] run tag @s add pc.reset_emerald_cost
execute as @e[tag=pc.clicked_interaction] run tag @s remove pc.clicked_interaction
execute as @e[tag=pc.emerald_in_hand] run tag @s remove pc.emerald_in_hand
execute as @e[tag=pc.reset_emerald_cost] run scoreboard players add @s pc.val 1
execute as @e[tag=pc.reset_emerald_cost] unless score @s pc.val matches 1..63 run scoreboard players set @s pc.val 1
execute as @e[tag=pc.reset_emerald_cost] at @s run function command_packer_core:price_tag
execute as @e[tag=pc.reset_emerald_cost] run tag @s remove pc.reset_emerald_cost
execute as @e[type=minecraft:interaction,tag=pc.origin_clicked_interaction] run data remove entity @s interaction
execute as @e[type=minecraft:interaction,tag=pc.origin_clicked_interaction] run tag @s remove pc.origin_clicked_interaction

scoreboard players set #pc_emerald_count_in_hand pc.val 0
execute at @e[type=minecraft:item_display,tag=pc.emerald] positioned ~ ~-1.22 ~ as @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,nbt={attack:{}},distance=..0.5,limit=1] run tag @s add pc.origin_clicked_interaction
execute as @e[type=minecraft:interaction,tag=pc.origin_clicked_interaction] at @s positioned ~ ~1.22 ~ if entity @e[type=minecraft:item_display,tag=pc.emerald,distance=..0.5] run tag @s add pc.clicked_interaction
execute as @e[tag=pc.clicked_interaction] on attacker if data entity @s SelectedItem{id:"minecraft:emerald"} run tag @s add pc.emerald_in_hand
execute as @e[tag=pc.clicked_interaction] run execute store result score #pc_emerald_count_in_hand pc.val run execute as @e[tag=pc.emerald_in_hand] run data get entity @s SelectedItem.Count
execute as @e[tag=pc.clicked_interaction] run scoreboard players operation #pc_emerald_cost pc.val = @s pc.val
execute as @e[tag=pc.clicked_interaction] run scoreboard players operation #pc_emerald_count_result pc.val = #pc_emerald_count_in_hand pc.val
execute as @e[tag=pc.clicked_interaction] run scoreboard players operation #pc_emerald_count_result pc.val -= #pc_emerald_cost pc.val
execute as @e[tag=pc.emerald_in_hand] if score #pc_emerald_count_result pc.val matches 0.. at @s run playsound minecraft:block.decorated_pot.insert player @s
execute as @e[tag=pc.emerald_in_hand] if score #pc_emerald_count_result pc.val matches ..-1 at @s run playsound block.decorated_pot.place player @s
execute as @e[tag=pc.emerald_in_hand] if score #pc_emerald_count_result pc.val matches 0.. run function command_packer_core:reset_selected_emeralid_count
execute as @e[tag=pc.clicked_interaction] at @s if score #pc_emerald_count_result pc.val matches 0.. run execute as @e[tag=pc.emerald_in_hand] run tag @s add ..
execute as @e[tag=pc.emerald_in_hand] run tag @s remove pc.emerald_in_hand
execute as @e[tag=pc.clicked_interaction] at @s if score #pc_emerald_count_result pc.val matches 0.. run summon minecraft:marker ~ ~0.55 ~ {Tags:["pc.command","pc.free"]}
execute at @e[tag=pc.clicked_interaction] positioned ~ ~1.22 ~ as @e[type=minecraft:item_display,tag=pc.emerald,distance=..0.5] if score #pc_emerald_count_result pc.val matches 0.. run tag @s add pc.price_locked
execute as @e[tag=pc.clicked_interaction] run tag @s remove pc.clicked_interaction
execute as @e[type=minecraft:interaction,tag=pc.origin_clicked_interaction] run data remove entity @s attack
execute as @e[type=minecraft:interaction,tag=pc.origin_clicked_interaction] run tag @s remove pc.origin_clicked_interaction


# 重复点击？
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s positioned ~ ~1.22 ~ run execute store result score #pc_emerald_exist pc.val run execute if entity @e[type=minecraft:item_display,tag=pc.emerald,distance=..0.5]
# 是重复点击->移除绿宝石标记
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s positioned ~ ~1.22 ~ if score #pc_emerald_exist pc.val matches 1 run kill @e[type=minecraft:item_display,tag=pc.emerald,distance=..0.5]
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s positioned ~ ~1.4 ~ if score #pc_emerald_exist pc.val matches 1 run kill @e[tag=pc.price_tag,distance=..0.5]
# 是重复点击->是命令方块->命令回档
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s if score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command run execute as @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5] at @s run data modify block ~ ~0.1 ~ Command set from entity @s Tags[0]

# 是重复点击->非陶罐->移除命令储存器
# execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s if score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command run kill @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5]
# 在极其特殊的情况下，可能会出现一些interaction，它内部的命令方块被替代或者摧毁了，因此不需要检测是否包含Command
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s if score #pc_emerald_exist pc.val matches 1 run kill @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5]
# 是重复点击->是陶罐->移除命令执行器
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s if score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot positioned ~ ~-1 ~ run kill @e[tag=pc.command_executer,distance=..0.5]
# 是重复点击->是陶罐->移除命令方块
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s if score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot run setblock ~ ~ ~ minecraft:air destroy
# 是重复点击->是陶罐->移除赠送的一枚绿宝石
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s if score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot run execute store result score #pc_command_executer_emerald_count pc.val run data get block ~ ~0.1 ~ item.Count
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s if score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot run scoreboard players remove #pc_command_executer_emerald_count pc.val 1
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s if score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot run execute store result block ~ ~0.1 ~ item.Count int 1 run scoreboard players get #pc_command_executer_emerald_count pc.val

# 非重复点击->检查绿宝石计数器(#pc_emerald_count)->生成不同种类的绿宝石标记
# 命令方块
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command if score #pc_emerald_count pc.val matches 0..9 run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_a"]}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command if score #pc_emerald_count pc.val matches 10..19 run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_b"]}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command if score #pc_emerald_count pc.val matches 20..29 run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_c"]}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command if score #pc_emerald_count pc.val matches 30.. run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_d"]}
# 空陶罐
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot unless data block ~ ~0.1 ~ item if score #pc_emerald_count pc.val matches 0..9 run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_a"]}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot unless data block ~ ~0.1 ~ item if score #pc_emerald_count pc.val matches 10..19 run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_b"]}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot unless data block ~ ~0.1 ~ item if score #pc_emerald_count pc.val matches 20..29 run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_c"]}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot unless data block ~ ~0.1 ~ item if score #pc_emerald_count pc.val matches 30.. run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_d"]}
# 绿宝石陶罐
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot if data block ~ ~0.1 ~ item{id:"minecraft:emerald"} if score #pc_emerald_count pc.val matches 0..9 run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_a"]}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot if data block ~ ~0.1 ~ item{id:"minecraft:emerald"} if score #pc_emerald_count pc.val matches 10..19 run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_b"]}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot if data block ~ ~0.1 ~ item{id:"minecraft:emerald"} if score #pc_emerald_count pc.val matches 20..29 run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_c"]}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot if data block ~ ~0.1 ~ item{id:"minecraft:emerald"} if score #pc_emerald_count pc.val matches 30.. run summon minecraft:item_display ~ ~1.22 ~ {item:{id:"minecraft:emerald",Count:1b},billboard:"fixed",transformation:{translation:[0f,0f,0f],scale:[0.5f,0.5f,0.5f],left_rotation:[0f,0f,0f,1f],right_rotation:[0f,0f,0f,1f]},Tags:["pc.emerald","pc.float_d"]}


# 非重复点击->有Command字段->生成命令存储器
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command run summon minecraft:interaction ~ ~ ~ {width:1.08f,height:1.08f,Tags:["pc.sign_up"]}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command run execute as @e[type=minecraft:interaction,tag=pc.sign_up,distance=..0.01] run scoreboard players set @s pc.val 1
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command run execute as @e[type=minecraft:interaction,tag=pc.sign_up,distance=..0.01] run tag @s remove pc.sign_up

execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command if score #pc_emerald_count pc.val matches 0..9 positioned ~ ~1.4 ~ run summon minecraft:text_display ~ ~ ~ {Tags:["pc.price_tag","pc.float_a"],text:'{"text":"1","color":"white","bold":true}',billboard:"center",default_background:0b,background:0,shadow:0b,glow_color_override:16777215,view_range:12,see_through:1b}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command if score #pc_emerald_count pc.val matches 10..19 positioned ~ ~1.4 ~ run summon minecraft:text_display ~ ~ ~ {Tags:["pc.price_tag","pc.float_b"],text:'{"text":"1","color":"white","bold":true}',billboard:"center",default_background:0b,background:0,shadow:0b,glow_color_override:16777215,view_range:12,see_through:1b}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command if score #pc_emerald_count pc.val matches 20..29 positioned ~ ~1.4 ~ run summon minecraft:text_display ~ ~ ~ {Tags:["pc.price_tag","pc.float_c"],text:'{"text":"1","color":"white","bold":true}',billboard:"center",default_background:0b,background:0,shadow:0b,glow_color_override:16777215,view_range:12,see_through:1b}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command if score #pc_emerald_count pc.val matches 30.. positioned ~ ~1.4 ~ run summon minecraft:text_display ~ ~ ~ {Tags:["pc.price_tag","pc.float_d"],text:'{"text":"1","color":"white","bold":true}',billboard:"center",default_background:0b,background:0,shadow:0b,glow_color_override:16777215,view_range:12,see_through:1b}

# 非重复点击->是陶罐->生成命令执行器
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot unless data block ~ ~0.1 ~ item run summon minecraft:interaction ~ ~-1 ~ {width:1.08f,height:1.08f,Tags:["pc.command_executer"]}
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot if data block ~ ~0.1 ~ item{id:"minecraft:emerald"} run summon minecraft:interaction ~ ~-1 ~ {width:1.08f,height:1.08f,Tags:["pc.command_executer"]}
# 非重复点击->是陶罐->生成命令方块
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot unless data block ~ ~0.1 ~ item run setblock ~ ~ ~ minecraft:command_block destroy
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot if data block ~ ~0.1 ~ item{id:"minecraft:emerald"} run setblock ~ ~ ~ minecraft:command_block destroy
# 非重复点击->是陶罐->填充一枚绿宝石
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot if data block ~ ~0.1 ~ item{id:"minecraft:emerald"} run execute store result score #pc_command_executer_emerald_count pc.val run data get block ~ ~0.1 ~ item.Count
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot if data block ~ ~0.1 ~ item{id:"minecraft:emerald"} run scoreboard players add #pc_command_executer_emerald_count pc.val 1
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot if data block ~ ~0.1 ~ item{id:"minecraft:emerald"} run execute store result block ~ ~0.1 ~ item.Count int 1 run scoreboard players get #pc_command_executer_emerald_count pc.val

execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot unless data block ~ ~0.1 ~ item run data modify block ~ ~0.1 ~ item set value {id:"minecraft:emerald",Count:1b}

execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if block ~ ~0.1 ~ minecraft:decorated_pot positioned ~ ~-1 ~ unless entity @e[type=minecraft:interaction,tag=pc.command_executer,distance=..0.5,limit=1] run tellraw @p [{"text":"此功能仅对空陶罐及绿宝石陶罐生效","color":"aqua"}]

# 检查头顶是否陶罐->不是->清理实体、扣除一枚赠送的绿宝石
execute as @e[tag=pc.command_executer] at @s unless block ~ ~1.2 ~ minecraft:decorated_pot run setblock ~ ~0.2 ~ minecraft:air
execute as @e[tag=pc.command_executer] at @s unless block ~ ~1.2 ~ minecraft:decorated_pot positioned ~ ~2.22 ~ run kill @e[tag=pc.emerald,distance=..0.5]
execute as @e[tag=pc.command_executer] at @s unless block ~ ~1.2 ~ minecraft:decorated_pot run execute store result score #pc_emerald_item_count pc.val run execute as @e[type=minecraft:item,nbt={Item:{id:"minecraft:emerald"}},sort=nearest,limit=1] run data get entity @s Item.Count
execute as @e[tag=pc.command_executer] at @s unless block ~ ~1.2 ~ minecraft:decorated_pot run scoreboard players remove #pc_emerald_item_count pc.val 1
execute as @e[tag=pc.command_executer] at @s unless block ~ ~1.2 ~ minecraft:decorated_pot run execute store result entity @e[type=minecraft:item,nbt={Item:{id:"minecraft:emerald"}},sort=nearest,limit=1] Item.Count int 1 run scoreboard players get #pc_emerald_item_count pc.val
execute as @e[tag=pc.command_executer] at @s unless block ~ ~1.2 ~ minecraft:decorated_pot run kill @s

# 非重复点击->是命令方块->命令转存至命令存储器
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command run execute as @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5] at @s run data modify entity @s Tags prepend string block ~ ~0.1 ~ Command
# 非重复点击->是命令方块->命令更改为触发器生成
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] at @s unless score #pc_emerald_exist pc.val matches 1 if data block ~ ~0.1 ~ Command run data modify block ~ ~0.1 ~ Command set value 'summon minecraft:marker ~ ~ ~ {Tags:["pc.command"]}'

# 点击->移除被点击NBT(attack:{})
execute as @e[tag=pc.raycast_block_shield,nbt={attack:{}}] run data remove entity @s attack

# 重置、初始化绿宝石计数器
execute unless score #pc_emerald_count pc.val matches 0..39 run scoreboard players set #pc_emerald_count pc.val 0

# 旋转、浮动绿宝石标记
execute as @e[type=item_display,tag=pc.float_a] at @s align xyz if score #pc_emerald_count pc.val matches 0 run tp @s ~0.5 ~0.22 ~0.5
execute as @e[type=item_display,tag=pc.float_b] at @s align xyz if score #pc_emerald_count pc.val matches 25 run tp @s ~0.5 ~0.22 ~0.5
execute as @e[type=item_display,tag=pc.float_c] at @s align xyz if score #pc_emerald_count pc.val matches 13 run tp @s ~0.5 ~0.22 ~0.5
execute as @e[type=item_display,tag=pc.float_d] at @s align xyz if score #pc_emerald_count pc.val matches 32 run tp @s ~0.5 ~0.22 ~0.5

execute as @e[type=text_display,tag=pc.float_a] at @s align xyz if score #pc_emerald_count pc.val matches 0 run tp @s ~0.5 ~0.4 ~0.5
execute as @e[type=text_display,tag=pc.float_b] at @s align xyz if score #pc_emerald_count pc.val matches 25 run tp @s ~0.5 ~0.4 ~0.5
execute as @e[type=text_display,tag=pc.float_c] at @s align xyz if score #pc_emerald_count pc.val matches 13 run tp @s ~0.5 ~0.4 ~0.5
execute as @e[type=text_display,tag=pc.float_d] at @s align xyz if score #pc_emerald_count pc.val matches 32 run tp @s ~0.5 ~0.4 ~0.5

execute as @e[tag=pc.float_a] if score #pc_emerald_count pc.val matches 0..19 at @s run tp @s ~ ~0.01 ~ ~-5 ~
execute as @e[tag=pc.float_a] if score #pc_emerald_count pc.val matches 20..39 at @s run tp @s ~ ~-0.01 ~ ~-5 ~

execute as @e[tag=pc.float_b] if score #pc_emerald_count pc.val matches 0..4 at @s run tp @s ~ ~0.01 ~ ~-5 ~
execute as @e[tag=pc.float_b] if score #pc_emerald_count pc.val matches 5..24 at @s run tp @s ~ ~-0.01 ~ ~-5 ~
execute as @e[tag=pc.float_b] if score #pc_emerald_count pc.val matches 25..39 at @s run tp @s ~ ~0.01 ~ ~-5 ~

execute as @e[tag=pc.float_c] if score #pc_emerald_count pc.val matches 0..12 at @s run tp @s ~ ~-0.01 ~ ~-5 ~
execute as @e[tag=pc.float_c] if score #pc_emerald_count pc.val matches 13..32 at @s run tp @s ~ ~0.01 ~ ~-5 ~
execute as @e[tag=pc.float_c] if score #pc_emerald_count pc.val matches 33..39 at @s run tp @s ~ ~-0.01 ~ ~-5 ~

execute as @e[tag=pc.float_d] if score #pc_emerald_count pc.val matches 0..12 at @s run tp @s ~ ~0.01 ~ ~-5 ~
execute as @e[tag=pc.float_d] if score #pc_emerald_count pc.val matches 13..32 at @s run tp @s ~ ~-0.01 ~ ~-5 ~
execute as @e[tag=pc.float_d] if score #pc_emerald_count pc.val matches 32..39 at @s run tp @s ~ ~0.01 ~ ~-5 ~

# 绿宝石计数器自增一
scoreboard players add #pc_emerald_count pc.val 1

# 重置、初始化触发器ID柄
execute unless entity @e[tag=pc.command] unless score #pc_command_id pc.val matches 0 run scoreboard players operation #pc_command_failed_count pc.val = #pc_command_id pc.val
execute unless entity @e[tag=pc.command] unless score #pc_command_id pc.val matches 0 run scoreboard players operation #pc_command_failed_count pc.val -= #pc_command_success_count pc.val
execute unless entity @e[tag=pc.command] unless score #pc_command_id pc.val matches 0 run tellraw @a [{"text":"本次成功执行","color":"aqua"},{"score":{"name":"#pc_command_success_count","objective":"pc.val"},"color":"aqua","bold":true},{"text":"条指令，失败执行","color":"aqua"},{"score":{"name":"#pc_command_failed_count","objective":"pc.val"},"color":"aqua","bold":true},{"text":"条指令，共消费","color":"aqua"},{"score":{"name":"#pc_command_total_cost","objective":"pc.val"},"color":"aqua","bold":true},{"text":"绿宝石","color":"aqua"}]
execute unless entity @e[tag=pc.command] run scoreboard players set #pc_command_id pc.val 0


# 未注册触发器->ID缺失->ID注册为触发器ID柄
execute as @e[tag=pc.command,tag=!pc.sign_up] unless score @s pc.val matches 0..2147483647 run tag @s add pc.sign_up
# 注册触发器(限制数量1)->注册ID
execute as @e[tag=pc.command,tag=pc.sign_up,limit=1] run scoreboard players operation @s pc.val = #pc_command_id pc.val
# 注册触发器(ID存在，限制数量1)->触发器ID柄增一
execute as @e[tag=pc.command,tag=pc.sign_up,scores={pc.val=0..},limit=1] run scoreboard players add #pc_command_id pc.val 1
# 注册触发器(ID存在，限制数量1)->移除注册标记
execute as @e[tag=pc.command,tag=pc.sign_up,scores={pc.val=0..},limit=1] run tag @s remove pc.sign_up

# 存在ID为0的触发器->重置'触发器最小ID'
execute as @e[tag=pc.command,scores={pc.val=0}] run scoreboard players set #pc_command_min_id pc.val 0
# '触发器最小ID'不与任何存在的触发器ID相等->'触发器最小ID'加一
execute unless score @e[tag=pc.command,scores={pc.val=0..},limit=1] pc.val = #pc_command_min_id pc.val run scoreboard players add #pc_command_min_id pc.val 1

# 触发器确认执行(#pc_command_executed = 1)->寻址 触发器执行位置->获取陶罐物品数量(#pc_command_executer_emerald_count)
execute if score #pc_command_executed pc.val matches 1 as @e[type=minecraft:marker,tag=pc.last_executed,limit=1] at @s run execute store result score #pc_command_executer_emerald_count pc.val run data get block ~ ~1 ~ item.Count
# 触发器确认执行(#pc_command_executed = 1)->寻址 触发器执行位置->获取命令执行结果(#pc_command_executer_return)
execute if score #pc_command_executed pc.val matches 1 as @e[type=minecraft:marker,tag=pc.last_executed,limit=1] at @s run execute store result score #pc_command_executer_return pc.val run data get block ~ ~ ~ SuccessCount
# 触发器确认执行->暂存指令费用
execute if score #pc_command_executed pc.val matches 1 if score #pc_command_executer_return pc.val matches 1.. run execute store result score #pc_emerald_cost pc.val run execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5,limit=1] run scoreboard players get @s pc.val
# 触发器确认执行->计算余额
execute unless entity @e[tag=pc.command,tag=pc.execute,tag=pc.free,limit=1] if score #pc_command_executed pc.val matches 1 if score #pc_command_executer_return pc.val matches 1.. run scoreboard players operation #pc_command_executer_emerald_count pc.val -= #pc_emerald_cost pc.val
# 触发器确认执行->命令执行成功->陶罐物品数量减N
execute if score #pc_command_executed pc.val matches 1 if score #pc_command_executer_return pc.val matches 1.. as @e[type=minecraft:marker,tag=pc.last_executed,limit=1] at @s run execute store result block ~ ~1 ~ item.Count int 1 run scoreboard players get #pc_command_executer_emerald_count pc.val

# 计算成功执行数、失败执行数，以及最终消费数
execute if score #pc_command_id pc.val matches 0 run scoreboard players set #pc_command_success_count pc.val 0
execute if score #pc_command_id pc.val matches 0 run scoreboard players set #pc_command_failed_count pc.val 0
execute if score #pc_command_id pc.val matches 0 run scoreboard players set #pc_command_total_cost pc.val 0
execute if score #pc_command_executed pc.val matches 1 if score #pc_command_executer_return pc.val matches 1.. as @e[type=minecraft:marker,tag=pc.last_executed,limit=1] at @s run scoreboard players add #pc_command_success_count pc.val 1
execute if score #pc_command_executed pc.val matches 1 if score #pc_command_executer_return pc.val matches 1.. as @e[type=minecraft:marker,tag=pc.last_executed,limit=1] at @s run scoreboard players operation #pc_command_total_cost pc.val += #pc_emerald_cost pc.val

# 权限回收
execute if score #pc_command_executed pc.val matches 1 as @e[tag=pc.command,tag=pc.execute,tag=pc.free,limit=1] run execute as @p[tag=..] run tag @s remove ..
execute if score #pc_command_executed pc.val matches 1 as @e[tag=pc.command,tag=pc.execute,limit=1] run kill @s

# 触发器执行待确认
scoreboard players set #pc_command_executed pc.val 0

# 将'触发器最小ID'对应触发器设置为待执行触发器
execute as @e[tag=pc.command,scores={pc.val=0..}] if score @s pc.val = #pc_command_min_id pc.val run tag @s add pc.execute
execute as @e[tag=pc.command,scores={pc.val=0..}] if score @s pc.val = #pc_command_min_id pc.val run tag @s add .

# 命令执行器不存在->触发器执行结束、函数返回
execute as @e[tag=pc.command,tag=pc.execute,limit=1] unless entity @e[type=minecraft:interaction,tag=pc.command_executer,sort=nearest,limit=1] run kill @s
execute as @e[tag=pc.command,tag=pc.execute,limit=1] unless entity @e[type=minecraft:interaction,tag=pc.command_executer,sort=nearest,limit=1] run return 1
# 命令存储器不存在->触发器执行结束、函数返回
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ unless entity @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5,limit=1] run kill @s
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ unless entity @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5,limit=1] run return 1

# 执行，选择命令执行器
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=pc.command_executer,sort=nearest,limit=1] run tag @s add pc.execute

# 现场没有存活触发器->将所有命令执行器命令方块的命令重置为空
execute unless entity @e[tag=pc.command,tag=pc.execute,limit=1] as @e[type=minecraft:interaction,tag=pc.command_executer] at @s run data modify block ~ ~0.1 ~ Command set value ''

# 陶罐物品为绿宝石？
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute at @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] run execute store success score #pc_command_executer_emerald_exist pc.val run execute if data block ~ ~1.1 ~ {item:{id:'minecraft:emerald'}}
# 暂存陶罐物品数量
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute at @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] run execute store result score #pc_command_executer_emerald_count pc.val run data get block ~ ~1.1 ~ item.Count
# 暂存指令费用
execute store result score #pc_emerald_cost pc.val run execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5,limit=1] run scoreboard players get @s pc.val

# 陶罐物品非绿宝石->移除命令执行器执行标记、触发器执行结束、函数返回
execute unless score #pc_command_executer_emerald_exist pc.val matches 1 run execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] run tag @s remove pc.execute
execute unless score #pc_command_executer_emerald_exist pc.val matches 1 run execute as @e[tag=pc.command,tag=pc.execute,limit=1] unless score #pc_command_executer_successcount pc.val matches 0 run kill @s
execute unless score #pc_command_executer_emerald_exist pc.val matches 1 run return 1
# 陶罐绿宝石数量低于2->移除命令执行器执行标记、触发器执行结束、函数返回
execute unless score #pc_command_executer_emerald_count pc.val matches 2.. unless entity @e[tag=pc.command,tag=pc.execute,tag=pc.free,limit=1] run execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] run tag @s remove pc.execute
execute unless score #pc_command_executer_emerald_count pc.val matches 2.. unless entity @e[tag=pc.command,tag=pc.execute,tag=pc.free,limit=1] run execute as @e[tag=pc.command,tag=pc.execute,limit=1] unless score #pc_command_executer_successcount pc.val matches 0 run kill @s
execute unless score #pc_command_executer_emerald_count pc.val matches 2.. unless entity @e[tag=pc.command,tag=pc.execute,tag=pc.free,limit=1] run return 1

# 陶罐绿宝石数量低于指令费用->移除命令执行器执行标记、触发器执行结束、函数返回
execute unless score #pc_command_executer_emerald_count pc.val > #pc_emerald_cost pc.val unless entity @e[tag=pc.command,tag=pc.execute,tag=pc.free,limit=1] run execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] run tag @s remove pc.execute
execute unless score #pc_command_executer_emerald_count pc.val > #pc_emerald_cost pc.val unless entity @e[tag=pc.command,tag=pc.execute,tag=pc.free,limit=1] run execute as @e[tag=pc.command,tag=pc.execute,limit=1] unless score #pc_command_executer_successcount pc.val matches 0 run kill @s
execute unless score #pc_command_executer_emerald_count pc.val > #pc_emerald_cost pc.val unless entity @e[tag=pc.command,tag=pc.execute,tag=pc.free,limit=1] run return 1

# 检查通过，正式执行->检查上次执行结果
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute at @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] run execute store result score #pc_command_executer_successcount pc.val run data get block ~ ~0.1 ~ SuccessCount

# 上次执行成功->填充待执行指令、重置执行结果为0、auto激发 执行命令
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5,limit=1] run execute at @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] if score #pc_command_executer_successcount pc.val matches 1.. run data modify block ~ ~0.1 ~ Command set from entity @s Tags[0]
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5,limit=1] run execute at @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] if score #pc_command_executer_successcount pc.val matches 1.. run data modify block ~ ~0.1 ~ SuccessCount set value 0
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] at @s if score #pc_command_executer_successcount pc.val matches 1.. run data modify block ~ ~0.1 ~ auto set value 1b
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] at @s if score #pc_command_executer_successcount pc.val matches 1.. run data modify block ~ ~0.1 ~ auto set value 0b

# 触发器执行待确认
scoreboard players set #pc_command_executed pc.val 0

# 条件判断->触发器确认执行、记录执行位置 生成或重置位置记录器
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5,limit=1] run execute at @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] if score #pc_command_executer_successcount pc.val matches 1.. run scoreboard players set #pc_command_executed pc.val 1
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5,limit=1] run execute at @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] if score #pc_command_executer_successcount pc.val matches 1.. run execute unless entity @e[type=minecraft:marker,tag=pc.last_executed] run summon minecraft:marker ~ ~0.1 ~ {Tags:['pc.last_executed']}
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=!pc.raycast_block_shield,distance=..0.5,limit=1] run execute at @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] if score #pc_command_executer_successcount pc.val matches 1.. run tp @e[type=minecraft:marker,tag=pc.last_executed] ~ ~0.1 ~

# 初始化、重置超时计数器
execute unless score #pc_command_outtime pc.val matches 0..10 run scoreboard players set #pc_command_outtime pc.val 0
# 超时计数器加一
scoreboard players add #pc_command_outtime pc.val 1
# 超时->上次执行失败->重置所有命令执行器命令方块执行结果为执行成功
execute if score #pc_command_outtime pc.val matches 11 run execute at @e[type=minecraft:interaction,tag=pc.command_executer] if score #pc_command_executer_successcount pc.val matches 0 run data modify block ~ ~0.1 ~ SuccessCount set value 1

# 移除命令执行器执行标记
execute as @e[tag=pc.command,tag=pc.execute,limit=1] at @s positioned ~ ~-0.5 ~ run execute as @e[type=minecraft:interaction,tag=pc.command_executer,tag=pc.execute,limit=1] run tag @s remove pc.execute
# 上次执行成功，命令已执行?->执行结束 否则下tick继续  备注：这条命令仅保证 pc.command 覆盖 生成->填充 生命周期，而没有覆盖 生成->填充->执行 完整的生命周期 现决定将 权限回收 延后，详见 # 权限回收
# execute as @e[tag=pc.command,tag=pc.execute,limit=1] unless score #pc_command_executer_successcount pc.val matches 0 run kill @s

# 正常情况下命令一tick内填充即结束，异常情况下等待超时计数器重置执行结果，再填充命令。
# 流程：tick 1 填充命令 并执行 -> tick 2 确认执行 检查执行结果 若成功则扣除绿宝石 否则不扣 -> tick 3 如果上一个命令执行失败，则此时无法填充新的命令，程序暂停-> tick n 超时重置 程序继续
# 这样，所有命令都会按照执行顺序依次执行，并且在有执行条件时执行，无执行条件时自动结束。

