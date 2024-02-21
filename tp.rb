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


class Projectile
  attr_reader :x, :y, :size, :speed


  def initialize(x, y, size, speed)
    @x = x
    @y = y
    @size = size
    @speed = speed
  end


  def update
    @y += @speed
  end


  def draw
    Square.new(x: @x, y: @y, size: @size, color: 'red')
  end
end


# Spawn a projectile every few seconds
def spawn_projectile
  projectiles << Projectile.new(rand(Window.width), 0, 10, 3)
end


projectiles = []


on :update do
  spawn_projectile if rand(60) == 0 # Spawn a projectile every 60 frames (approx. 1 second)
  projectiles.each(&:update)
  projectiles.reject! { |projectile| projectile.y > Window.height }
end

draw do
  background.draw
  hero.draw


  projectiles.each(&:draw)
end


def update_hitbox(hitbox, hero)
  hitbox.x = hero.x + hero.width * 0.325  # Justera horisontell position för att centrera hitboxen
  hitbox.y = hero.y + hero.height * 0.1  # Justera vertikal position för att centrera hitboxen
  hitbox.size = hero.width * 0.4  # Justera storlek för att passa hjältens storlek
end


hitbox = Square.new(color: [1, 0, 1, 0.4], size: hero.width * 0.5)  # Justera storlek för att passa hjältens storlek


def is_hitbox_colliding_with_projectiles?(hitbox, projectiles)
  projectiles.any? do |projectile|
    hitbox.contains?(projectile.x, projectile.y) ||
      hitbox.intersects?(projectile)  # Check for both containment and intersection
  end
end


on :update do
  # Spawn projectiles
  spawn_projectile if rand(60) == 0


  # Update projectiles and check for collisions
  projectiles.each(&:update)
  projectiles.reject! { |projectile| projectile.y > Window.height }


  # Check if hitbox is colliding with any projectile
  if is_hitbox_colliding_with_projectiles?(hitbox, projectiles)
    # Handle collision here, e.g., change hero color, play sound, etc.
    hero.color = 'red'
  else
    hero.color = 'white'  # Reset hero color if no collision
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


  # Uppdatera hitbox position
  update_hitbox(hitbox, hero)
end


on :key_up do
  hero.stop
end


show



