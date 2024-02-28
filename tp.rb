require 'ruby2d'  # Kallar på ruby2d biblioteket

set width: 800  # Definierar bredd för fönstret
set height: 600  # Definierar höjd för fönstret

WALK_SPEED = 6  # Gånghastighet
HEART_SIZE = 20  # Hjärtstorlek
HEART_SPEED = 3  # Hjärthastighet
HEART_FREQUENCY = 3  # Antalet hjärtan som ska falla

background = Image.new('background.jpg')  # Bestämmer bakgrundsbilden
hero = Sprite.new(  # Bestämmer storlek och position för spelgubben
  'hero.png',
  width: 200,
  height: 200,
  clip_width: 256,
  y: 256
)

def update_hitbox(hitbox, hero)  # Funktion för att uppdatera hitboxens position och storlek baserat på hjältens position och storlek
  hitbox.x = hero.x + hero.width * 0.25
  hitbox.y = hero.y + hero.height * 0.25
  hitbox.size = hero.width * 0.5
end

hitbox = Square.new(color: [1, 0, 1, 0], size: hero.width * 0.5)  # Osynlig hitbox för kollision


hearts = []  # Array för hjärtan

on :key_held do |event|  #Knapptryckningar för att flytta spelgubben
  case event.key
  when 'left'
    hero.play flip: :horizontal

    if hero.x > 0
      hero.x -= WALK_SPEED
    else
      if background.x < 0
        background.x += WALK_SPEED
      end
    end
  when 'right'
    hero.play
    if hero.x < (Window.width - hero.width)
      hero.x += WALK_SPEED
    else
      if (background.x - Window.width) > -background.width
        background.x -= WALK_SPEED
      end
    end
  end

  update_hitbox(hitbox, hero)  # Uppdatera hitboxens position och storlek
end

update do  # Uppdaterar spelvärlden
  if rand(100) < HEART_FREQUENCY  # Justerar frekvensen för hjärtskapande
    hearts << Image.new('heart.jpg', x: rand(Window.width), y: 0, width: HEART_SIZE, height: HEART_SIZE)  # Lägger till ett nytt hjärta i arrayen
  end

  hearts.each do |heart|
    heart.y += HEART_SPEED  # Justerar hastigheten på fallande hjärtan

    if hitbox.contains?(heart.x, heart.y) && heart.y + HEART_SIZE >= hero.y && heart.x + HEART_SIZE >= hero.x && heart.x <= hero.x + hero.width  # Kollar om hjärtat kolliderar med hjälten
      puts "Game Over!"  # Skriver ut "Game Over!" i terminalen
      close  # Stänger ner spelet
    end

    if heart.y > Window.height + HEART_SIZE  # Om hjärtat passerar nerför fönstret
      heart.remove  # Ta bort hjärtat från skärmen
      hearts.delete(heart)  # Ta bort hjärtat från arrayen
    end
  end
end

on :key_up do  # Knapptryckningar när en knapp släpps
  hero.stop  # Stannar spelgubbens rörelse
end

show  # Visar fönstret för spelaren
