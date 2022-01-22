import json
import random

with open(r'..\data\processed\wordle_words.json') as infile:
	word_list = json.load(infile)

class Wordle:
    def __init__(self, word=None, n_guesses=6, n_letters=5, all_words=word_list):
        if word == None:
            self.word = random.sample(set(all_words), 1)[0]
        else:
            self.word = word.upper()
        self.n_guesses = n_guesses
        self.n_letters = n_letters
        self.guess_counter = n_guesses
        self.greens = [None] * self.n_letters 
        self.current_yellows = [None] * self.n_letters
        self.yellows = {i: [] for i in range(self.n_letters)}
        self.guessed_words = []
        self.all_words = [word.upper() for word in all_words]
        self.absent_letters = []
        self.present_letters = []
        self.correct_positions = [None] * self.n_letters # greens would be differnt per guess, remember correct positions
        self.state = None
        self.qstate = [0] * self.n_letters
        self.tmp_qstate = [0] * self.n_letters
        self.win = ''
        self.yellowlist = []
        
    def try_word (self, guess):
        # need to add a check for not doing anything if the word is already guessed correctly
        guess = guess.upper()
        self.state = None
        self.current_yellows = [None]* self.n_letters # yellows have to reset each time
        self.greens = [None] * self.n_letters
        self.tmp_qstate = [0] * self.n_letters
        
        print('guessed: ', guess)
        if not len(guess) == self.n_letters:
            raise ValueError('wrong word length')
        if guess not in self.all_words:
            raise ValueError('invalid word')
        if guess in self.guessed_words:
            raise ValueError('word already guessed')
        self.guessed_words.append(guess)
        # c_g = character_guess,  c_w = character_word
        for i, (c_g, c_w) in enumerate(zip(guess, self.word)):
            if c_g == c_w:
                self.greens[i] = c_g
                self.correct_positions[i] = c_g
                self.qstate[i] = 1
                self.tmp_qstate[i] = 1
            # Check for number of non-None in greens list 
            if sum(bool(char) for char in self.greens) == self.n_letters:
                self.state = True
                self.win ='win'
                print('victory! word is: ' + self.word) 
                grn_sum = sum([x!=None for x in self.greens])
                yel_sum = sum([x!=None for x in self.current_yellows])
                return grn_sum, yel_sum
            if c_g in self.word and c_g != c_w:
                self.yellows[i].append(c_g)
                self.current_yellows[i] = c_g
                if c_g not in self.yellowlist:
                    self.yellowlist += c_g
            if c_g in self.word: # track the letters that are there for the AI later
                self.present_letters.append(c_g)
            if c_g not in self.word: # track letters that are not there for the AI
                self.absent_letters.append(c_g)
        self.guess_counter -= 1
        grn_sum = sum([x!=None for x in self.greens])
        yel_sum = sum([x!=None for x in self.current_yellows])
        
        if self.guess_counter == 0:
            self.state=True
            self.win = 'lose'
            print("YOU LOSE-TOO MANY GUESSES")
            return grn_sum, yel_sum # return number of greens and number of yellows
        print('Greens:' + str(self.greens) + 
              '\nYellows: ' + str(self.yellows) + 
              '\nGuesses left: ' + str(self.guess_counter))

        return grn_sum, yel_sum # return number of greens and number of yellows
        