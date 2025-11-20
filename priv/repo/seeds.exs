# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AiOrHuman.Repo.insert!(%AiOrHuman.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias AiOrHuman.Game

# Add some test pairs (use placeholder URLs for now)
Game.create_image_pair(%{
  ai_url: "images/ai_banana.png",
  human_url: "images/real_banana.jpg"
})

Game.create_image_pair(%{
  ai_url: "images/ai_hotdog.jpg",
  human_url: "images/real_hotdog.jpg"
})
