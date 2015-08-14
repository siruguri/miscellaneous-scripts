require "capybara"
require 'capybara/poltergeist'
#require 'pry-byebug'

class RtMoviefinderCrawler
  attr_reader :session, :words
  
  def initialize
    @session = Capybara::Session.new(:selenium)
    @words = ["92 in the Shade", "Aaron Loves Angela", "The Adventure of Sherlock Holmes' Smarter Brother", "The Adventures of the Wilderness Family", "Aloha, Bobby and Rose", "The Apple Dumpling Gang", "At Long Last Love", "Barry Lyndon", "Bite the Bullet", "The Black Bird", "Black Fist", "Blazing Stewardesses", "Boss Nigger", "A Boy and His Dog", "Brannigan", "Breakheart Pass", "Breakout", "Brother, Can You Spare a Dime?", "Bug", "Bugs Bunny: Superstar", "Capone", "Cleopatra Jones and the Casino of Gold", "Cooley High", "Coonskin", "Crazy Mama", "The Day of the Locust", "Death Race 2000", "The Devil's Rain", "Diamonds", "Doc Savage: The Man of Bronze", "Dog Day Afternoon", "Dolemite", "The Drowning Pool", "The Eiger Sanction", "Escape to Witch Mountain", "Farewell, My Lovely", "The Fortune", "Framed", "French Connection II", "Funny Lady", "The Giant Spider Invasion", "Give 'em Hell, Harry!", "The Great Waldo Pepper", "Grey Gardens", "The Happy Hooker", "Hard Times", "Hearts of the West", "Hester Street", "The Hiding Place", "The Hindenburg", "Hustle", "I Wonder Who's Killing Her Now?", "Jaws", "The Killer Elite", "The Land That Time Forgot", "Let's Do It Again", "Love and Death", "Lucky Lady", "Mahogany", "Man Friday", "The Man in the Glass Booth", "The Man Who Would Be King", "Mandingo", "The Master Gunfighter", "Milestones", "Mitchell", "Moonrunners", "Mr. Ricco", "Nashville", "Night Moves", "The Noah", "Once Is Not Enough", "One Flew Over the Cuckoo's Nest", "One of Our Dinosaurs Is Missing", "Operation: Daybreak", "The Other Side of the Mountain", "Peeper", "Permission to Kill", "Posse", "The Prisoner of Second Avenue", "Queen of the Stardust Ballroom", "Race with the Devil", "Rafferty and the Gold Dust Twins", "Rancho Deluxe", "The Reincarnation of Peter Proud", "Return to Macon County", "The Rocky Horror Picture Show", "Rollerball", "Rooster Cogburn", "Russian Roulette", "Shampoo", "Sheba, Baby", "Smile", "The Spiral Staircase", "The Stepford Wives", "The Strongest Man in the World", "The Sunshine Boys", "Supervixens", "Switchblade Sisters", "Take a Hard Ride", "Three Days of the Condor", "Thundercrack!", "Trucker's Woman", "Tubby the Tuba", "The Ultimate Warrior", "W.W. and the Dixie Dancekings", "Walking Tall Part 2", "The Werewolf of Woodstock", "White Line Fever", "The Wild Party", "The Wind and the Lion"]
  end
end

l=RtMoviefinderCrawler.new

url = ARGV[0] || 'http://www.rottentomatoes.com'
l.session.visit url

l.words.each do |term|
  l.session.fill_in('search-term', with: term)
  sleep 2
  ls = l.session.all('li.searchResult a')
  ls.each do |l_elt|
    puts l_elt[:href]
  end
end

