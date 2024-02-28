require 'ruby2d'

set width: 800
set height: 600

WALK_SPEED = 6
CIRCLE_SIZE = 15
CIRCLE_SPEED = 5  # You can adjust this value
CIRCLE_FREQUENCY = 5  # You can adjust this value

background = Image.new('background.jpg')
hero = Sprite.new(
  'hero.png',
  width: 200,
  height: 200,
  clip_width: 256,
  y: 256
)

def update_hitbox(hitbox, hero)
  hitbox.x = hero.x + hero.width * 0.25
  hitbox.y = hero.y + hero.height * 0.25
  hitbox.size = hero.width * 0.5
end

hitbox = Square.new(color: [1, 0, 1, 0], size: hero.width * 0.5) # Transparent hitbox

update_hitbox(hitbox, hero)

circles = []

on :mouse_move do |event|
  if hitbox.contains?(event.x, event.y)
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

  update_hitbox(hitbox, hero)
end

update do
  if rand(100) < CIRCLE_FREQUENCY  # Adjust frequency of circle creation
    circles << Circle.new(x: rand(Window.width), y: 0, radius: CIRCLE_SIZE, color: 'red')
  end

  circles.each do |circle|
    circle.y += CIRCLE_SPEED  # Adjust speed of falling circles

    if hitbox.contains?(circle.x, circle.y) && circle.y + CIRCLE_SIZE >= hero.y && circle.x + CIRCLE_SIZE >= hero.x && circle.x <= hero.x + hero.width
      puts "Game Over!"
      close
    end

    if circle.y > Window.height + CIRCLE_SIZE
      circle.remove
      circles.delete(circle)
    end
  end
end

on :key_up do
  hero.stop
end

show
