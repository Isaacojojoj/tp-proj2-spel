require 'ruby2d'

set width: 800
set height: 600

WALK_SPEED = 6

background = Image.new('background.jpg')
hero = Sprite.new(
  'hero.png',
  width: 200,
  height: 200,
  clip_width: 256,
  y: 256
)

# Define the hitbox but do not initially show it
hitbox = Square.new(color: [1, 0, 1, 0], size: hero.width * 0.5, z: 1)  # Assigning z-index to ensure hitbox appears above hero

on :mouse_move do |event|
  if hitbox.contains?(event.x, event.y)
    # Only change the hero's color if the mouse is over the hitbox
    hero.color.g = 0
  else
    hero.color.g = 1
  end
end

on :key_held do |event|
  case event.key
  when 'left'
    hero.play flip: :horizontal

    if hero.x > 0
      hero.x -= WALK_SPEED
      hitbox.x -= WALK_SPEED  # Update hitbox position along with hero
    else
      if background.x < 0
        background.x += WALK_SPEED
      end
    end
  when 'right'
    hero.play
    if hero.x < (Window.width - hero.width)
      hero.x += WALK_SPEED
      hitbox.x += WALK_SPEED  # Update hitbox position along with hero
    else
      if (background.x - Window.width) > -background.width
        background.x -= WALK_SPEED
      end
    end
  end
end

on :key_up do
  hero.stop
end

show
