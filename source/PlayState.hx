package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;

using flixel.util.FlxSpriteUtil;

class EntityType
{
	public static inline var PLAYER:String = "player";
	public static inline var ENEMY:String = "enemy";
	public static inline var BOSS:String = "boss";
	public static inline var COIN:String = "coin";
}

class PlayState extends FlxState
{
	var player:Player;
	
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var coins:FlxTypedGroup<Coin>;
	var enemies:FlxTypedGroup<Enemy>;

	var hud:HUD;
	var money:Int = 0;
	var health:Int = 3;

	var inCombat:Bool = false;
	var combatHUD:CombatHUD;

	override public function create():Void
	{
		map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room_001__json);
		
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.setTileProperties(1, FlxObject.NONE);
		walls.setTileProperties(2, FlxObject.ANY);
		add(walls);

		coins = new FlxTypedGroup<Coin>();
		add(coins);

		enemies = new FlxTypedGroup<Enemy>();
		add(enemies);
		
		player = new Player();
		add(player);
		
		hud = new HUD();
		add(hud);
		
		map.loadEntities(placeEntities, "entities");
		FlxG.camera.follow(player, TOPDOWN, 1);

		combatHUD = new CombatHUD();
		add(combatHUD);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (inCombat)
		{
			if (!combatHUD.visible)
			{
				health = combatHUD.playerHealth;
				hud.updateHUD(health, money);
				if (combatHUD.outcome == VICTORY)
				{
					combatHUD.enemy.kill();
				}
				else
				{
					combatHUD.enemy.flicker();
				}
				inCombat = false;
				player.active = true;
				enemies.active = true;
			}
		}
		else
		{
			FlxG.collide(player, walls);
			FlxG.overlap(player, coins, playerTouchCoin);
			FlxG.collide(enemies, walls);
			enemies.forEachAlive(checkEnemyVision);
			FlxG.overlap(player, coins, playerTouchEnemy);

		}
		// super.update(elapsed);
	}

	private function placeEntities(entity:EntityData):Void
	{
		switch (entity.name)
		{
			case EntityType.PLAYER:
				player.setPosition(entity.x, entity.y);
			case EntityType.ENEMY:
				enemies.add(new Enemy(entity.x + 4, entity.y, REGULAR));
			case EntityType.BOSS:
				enemies.add(new Enemy(entity.x + 4, entity.y, BOSS));
			case EntityType.COIN:
				coins.add(new Coin(entity.x + 4, entity.y + 4));
		}
	}

	private function playerTouchCoin(player:Player, coin:Coin):Void
	{
		if (player.alive && player.exists && coin.alive && coin.exists)
		{
			coin.kill();
			money++;
			hud.updateHUD(health, money);
		}
	}

	private function playerTouchEnemy(player:Player, enemy:Enemy):Void
	{
		if (player.alive && player.exists && enemy.alive && enemy.exists && !enemy.isFlickering())
		{
			startCombat(enemy);
		}
	}

	private function startCombat(enemy:Enemy):Void
	{
		inCombat = true;
		player.active = false;
		enemies.active = false;
		combatHUD.initCombat(health, enemy);
	}

	private function checkEnemyVision(enemy:Enemy):Void
	{
		if (walls.ray(enemy.getMidpoint(), player.getMidpoint()))
		{
			enemy.seesPlayer = true;
			enemy.playerPosition = player.getMidpoint();
		}
		else
		{
			enemy.seesPlayer = false;
		}
	}
}
