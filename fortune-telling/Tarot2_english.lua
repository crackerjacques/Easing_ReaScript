-- Tarots
local cards = {
{name = "The Fool", upright = "New beginnings, freedom, journey", reversed = "Recklessness, failure, lack of planning"},
{name = "The Magician", upright = "Creation, talent, willpower", reversed = "Instability, self-centeredness, lack of imagination"},
{name = "The High Priestess", upright = "Knowledge, intuition, mysticism", reversed = "Ignorance, superstition, disbelief"},
{name = "The Empress", upright = "Motherhood, abundance, love", reversed = "Dependency, vanity, conflict"},
{name = "The Emperor", upright = "Authority, confidence, responsibility", reversed = "Tyranny, control, irresponsibility"},
{name = "The Hierophant", upright = "Tradition, faith, knowledge", reversed = "Hypocrisy, dogmatism, conservatism"},
{name = "The Lovers", upright = "Love, passion, harmony", reversed = "Adultery, disharmony, jealousy"},
{name = "The Chariot", upright = "Victory, confidence, willpower", reversed = "Defeat, self-destruction, recklessness"},
{name = "Strength", upright = "Strength, harmony, confidence", reversed = "Self-centeredness, weakness, disharmony"},
{name = "The Hermit", upright = "Solitude, introspection, self-discovery", reversed = "Isolation, anxiety, concealment"},
{name = "The Wheel of Fortune", upright = "Turning point, destiny, progress", reversed = "Stagnation, missed opportunity, confusion"},
{name = "Justice", upright = "Justice, fairness, morality", reversed = "Prejudice, injustice, corruption"},
{name = "The Hanged Man", upright = "Sacrifice, concern, service", reversed = "Egoism, needless sacrifice, self-harm"},
{name = "Death", upright = "Transition, change, growth", reversed = "Stagnation, decay, stoppage"},
{name = "Temperance", upright = "Moderation, balance, middle ground", reversed = "Excess, waste, self-centeredness"},
{name = "The Devil", upright = "Bondage, immorality, corruption", reversed = "Release, freedom, inner peace"},
{name = "The Tower", upright = "Collapse, destruction, upheaval", reversed = "Recovery, regeneration, rebuilding"},
{name = "The Star", upright = "Hope, serenity, harmony", reversed = "Anxiety, disappointment, delusion"},
{name = "The Moon", upright = "Instability, confusion, unreality", reversed = "Stability, intuition, creativity"},
{name = "The Sun", upright = "Happiness, light, abundance", reversed = "Decline, depression, shallowness"},
{name = "Judgment", upright = "Transition, decision, rebirth", reversed = "Rejection, finality, ending"},
{name = "The World", upright = "Completion, fulfillment, achievement", reversed = "Incompletion, giving up halfway, inadequacy"}

}

-- Draw 2 tarots
local card1 = cards[math.random(#cards)]
local card2 = cards[math.random(#cards)]

-- upright or reverse
local upright1 = math.random(2) == 1
local upright2 = math.random(2) == 1

-- upright or reverse 2
local function get_card_meaning(card, upright)
  if upright then
    return card.upright
  else
    return card.reversed
  end
end

-- combination and mean
reaper.ShowMessageBox(
  "Your card is \n\n" ..
  card1.name .. (upright1 and "(forward position)" or "(reverse position)") .. "and \n" ..
  card2.name .. (upright2 and "(positive position)" or "(reverse position)") .. "is. \n\n" ..
  "Meaning of the first card:\n" ..
  get_card_meaning(card1, upright1) .."\n\n" ..
  "meaning of the second card:\n" ..
  get_card_meaning(card2, upright2),
  "Tarot card combination",

  0)

