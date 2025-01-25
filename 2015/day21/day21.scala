import scala.io.Source
import scala.collection.mutable.HashMap
import scala.collection.mutable.HashSet

class Opponent(val name: String, val attack: Int, val defense: Int, var hitPoints: Int = 100) 

def loadOpponent(filename: String): Opponent = {
    val source = Source.fromFile(filename)
    var attack: Int = 0
    var defense: Int = 0
    var hitPoints: Int = 100

    for (line <- source.getLines())     {
        val fields = line.split(": ")
        val name = fields(0)
        val value = fields(1).toInt
        if (name == "Hit Points") {
            hitPoints = value
        } else if (name == "Damage") {
            attack = value
        } else if (name == "Armor") {
            defense = value
        }
    }
    source.close()
    new Opponent("Boss", attack, defense, hitPoints)
}

class Item(val name: String, val cost: Int, val damage: Int, val defense: Int)

def playerWins(player: Opponent, boss: Opponent): Boolean = {

    val playerDamage = (player.attack - boss.defense).max(1)
    val bossDamage = (boss.attack - player.defense).max(1)
    // println(s"player does ${playerDamage}, boss does ${bossDamage}")
    var round = 0
    while (player.hitPoints > 0 && boss.hitPoints > 0) {
        round = round + 1
        boss.hitPoints -= playerDamage
        // println(s"$round: player hits boss, boss has ${boss.hitPoints} HP")
        if (boss.hitPoints > 0) { 
            player.hitPoints -= bossDamage
            round = round + 1
            // println(s"$round: boss hits player, player has ${boss.hitPoints} HP")
            // if (player.hitPoints < 0) { 
            //     println("Boss wins!")
            // }
        }
    }
    player.hitPoints > 0
}

def main(args: Array[String]) = {
    if (args.length == 0) {
        val program = new Exception().getStackTrace.head.getFileName
        System.err.println(s"Usage: $program filename")
        System.exit(1)
    }
    val bossTemplate = loadOpponent(args(0))

    val weapons = List(
        new Item( "Dagger",  8, 4, 0),
        new Item( "Shortsword", 10, 5, 0),
        new Item( "Warhammer", 25, 6, 0),
        new Item( "Longsword", 40, 7, 0),
        new Item( "Greataxe", 74, 8, 0)
    )
    
    val armors = List(
        new Item( "None", 0,   0, 0),
        new Item( "Leather", 13,  0, 1),
        new Item( "Chainmail", 31,  0, 2),
        new Item( "Splintmail", 53,  0, 3),
        new Item( "Bandedmail", 75,  0, 4),
        new Item( "Platemail", 102, 0, 5)
    )
    
    val rings = List(
        new Item( "Damage+1", 25,  1, 0 ),
        new Item( "Damage+2", 50,  2, 0 ),
        new Item( "Damage+3", 100, 3, 0 ),
        new Item( "Defense+1", 20,  0, 1 ),
        new Item( "Defense+2", 40,  0, 2 ),
        new Item( "Defense+3", 80,  0, 3 )
    )

    val ringSets = (HashSet() ++ rings).subsets.toList.filter(_.size <= 2)

    var minCost = Double.PositiveInfinity

    for (weapon <- weapons) {
        for (armor <- armors) {
            for (ringSet <- ringSets) {
                // print(s"""weapon: ${weapon.name}, armor: ${armor.name}, rings: """)
                var ringDamage  = 0
                var ringDefense = 0
                var ringCost = 0
                if (ringSet.size > 0) {
                    // var first = true
                    for (ring <- ringSet) {
                        // if (!first) { print(", "); }
                        // first = false
                        // print(ring.name)
                        ringCost = ringCost + ring.cost
                        ringDamage = ringDamage + ring.damage
                        ringDefense = ringDefense + ring.defense
                    }
                } 
                // else {
                //     print("None")
                // }

                val cost = weapon.cost + armor.cost + ringCost
                val attack = weapon.damage + armor.damage + ringDamage
                val defense = weapon.defense + armor.defense + ringDefense
                val player = new Opponent("Player", attack, defense)
                val boss   =  Opponent("Boss", bossTemplate.attack, bossTemplate.defense, bossTemplate.hitPoints)
                if (playerWins(player, boss) && cost < minCost)
                    minCost = cost
                // println(s", cost: ${cost}, attack: ${attack}, defense: ${defense}")
                // println(s"Result: ${playerWins(player, boss)}")
            }
        }
    }
    println(s"minimum cost to win: ${minCost}")
}
