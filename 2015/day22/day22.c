#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct spell {
    char name[14];
    int cost;
    int damage;
    int healing;
    int armor;
    int mana;
    int duration;
} spell;

typedef struct active_spell {
    struct spell *prototype;
    int timer;
    struct active_spell *next;
} active_spell;

active_spell *cast(active_spell *active_list, spell *prototype) {
    active_spell *instance = (active_spell *)malloc(sizeof(active_spell));
    instance->next = active_list;
    instance->prototype = prototype;
    instance->timer = prototype->duration;
    return instance;
}

spell all_spells[] = { { "Magic Missile", 53, 4, 0, 0,   0, 1 },
                       { "Drain",         73, 2, 2, 0,   0, 1 },
                       { "Shield",       113, 0, 0, 7,   0, 6 },
                       { "Poison",       173, 3, 0, 0,   0, 6 },
                       { "Recharge",     229, 0, 0, 0, 101, 5 } };

#define SPELL_COUNT (sizeof(all_spells) / sizeof(spell))

typedef struct opponent {
    char name[7];
    int attack;
    int defense;
    int hit_points;
    int mana;
} opponent;

int play(opponent *player, opponent *boss, active_spell *active_list, int min_mana, int mana_spent, int turn) {

    if (player->hit_points <= 0 || player->mana <= 0) {
        return INT_MAX; // player loses, so pretend we spent infinite mana
    }
    if (boss->hit_points <= 0) {
        return mana_spent < min_mana ? mana_spent : min_mana;
    }
    if (turn == 0) { /* player's turn */
        for (int i=0; i<SPELL_COUNT; ++i) {
            if (all_spells[i].mana <= player->mana) {
                player->mana -= all_spells[i].mana;
                active_spell *old_active = active_list;
                active_list = cast(active_list, &all_spells[i]);
            int mana = play(
        }
    }
    

    return 0;
}

opponent *load_boss(char *filename, opponent *o) {
    char line[16];
    char field_name[12];
    int field_value, count, add;
    FILE *input = fopen(filename, "r");
    if (!input) {
        return 0;
    }
    strcpy(o->name, "Boss");
    o->mana = o->defense = 0;

    while (!feof(input)) {
        fgets(line, sizeof(line), input);
        sscanf(line, "%s%n", field_name, &count);
        if (0 == strcmp(field_name, "Hit")) {
            field_name[count] = ' ';
            count += sscanf(line+count + 1, "%s%n", field_name + count + 1, &add);
            count += add;
        }
        sscanf(line + count, "%d", &field_value);
        if (0 == strcmp(field_name, "Hit Points:")) {
            o->hit_points = field_value;
        } else if (0 == strcmp(field_name, "Damage:")) {
            o->attack = field_value;
        } else {
            fprintf(stderr, "Unknown field '%s'\n", field_name);
        }
    }
    fclose(input);
    return o;
}

int main(int argc, char *argv[]) {

    if (argc != 2) {
        fprintf(stderr, "Usage: %s input-file\n", argv[0]);
        exit(1);
    }

    opponent player_template = { "Player", 0, 0, 50, 500 };
    opponent boss_template;

    if (!load_boss(argv[1], &boss_template)) {
        fprintf(stderr, "%s: Unable to open file '%s'\n", argv[0], argv[1]);
        exit(1);
    }

    printf("Fighting %s with %d hit points and dealing %d damage\n",
        boss_template.name, boss_template.hit_points, boss_template.attack);

    printf("There are %lu spells\n", SPELL_COUNT);

    opponent player, boss;
    memcpy(&player, &player_template, sizeof(opponent));
    memcpy(&boss, &boss_template, sizeof(opponent));
    printf("%d", play(&player, &boss, NULL));
}
