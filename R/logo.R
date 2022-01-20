install.packages("ggseqlogo")

library(ggseqlogo)
setwd('GitHub/wordle-opt')

# words are from http://norvig.com/google-books-common-words.txt 
# filtered for only 5 letter words in python

w<-read.csv('5-letter.csv')
print(nrow(w)) # w contains df of all 10541 words and their counts
head(w)

w5<-read.csv('5-letter-top5000.csv') # only the top 5000 words and their counts

# example data
data(ggseqlogo_sample)
seqs_dna

### make custom color scheme
isVowel <- function(char) char %in% c('A', 'E', 'I', 'O', 'U')

groups<- c()
color_vec<-c()
for (l in LETTERS){
  if(isVowel(l)){
    groups<-c(groups, 'vowel')
    color_vec<-c(color_vec, 'red')
  }
  else{
    groups <- c(groups, 'consonant')
    color_vec<- c(color_vec, 'black')
  } 
}
groups  
color_vec

cs1 = make_col_scheme(chars=LETTERS, 
                      groups=groups,
                      cols=color_vec)


# make a list of both word sets for side-by-side plotting
wlist = list('top 5,000 words'=w5$word, 'all 10,541 words'=w$word)

# plot probability logo for all words and save as SVG
dev.off()
svg('plots/plogo-both.svg')
ggseqlogo(wlist, method='p', namespace=LETTERS, col_scheme=cs1) 
dev.off()

dev.off()
svg('plots/plogo-all10541.svg')
ggseqlogo(w$word, method='p', namespace=LETTERS, col_scheme=cs1) 
dev.off()

# plot probability logo for top 5000 words and save as SVG
svg('plots/plogo-top5000.svg')
ggseqlogo(w5$word, method='p', namespace=LETTERS, col_scheme=cs1)
dev.off()

# plot probability logo for all words and save as SVG
dev.off()
svg('plots/bitlogo-both.svg')
ggseqlogo(wlist, namespace=LETTERS, col_scheme=cs1) 
dev.off()

dev.off()
svg('plots/bitlogo-all10541.svg')
ggseqlogo(w$word, namespace=LETTERS,  col_scheme=cs1)
dev.off()

dev.off()
svg('plots/bitlogo-top5000.svg')
ggseqlogo(w5$word, namespace=LETTERS,  col_scheme=cs1)
dev.off()





