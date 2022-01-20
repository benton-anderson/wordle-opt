install.packages("ggseqlogo")

library(ggseqlogo)
setwd('GitHub/wordle-opt')

# words are from http://norvig.com/google-books-common-words.txt 
# filtered for only 5 letter words in python

w<-read.csv('5-letter.csv')
print(nrow(w)) # w contains df of all 10541 words and their counts
head(w)

w5<-read.csv('5-letter-top5000.csv') # only the top 5000 words and their counts



### make custom color scheme
isVowel <- function(char) char %in% c('A', 'E', 'I', 'O', 'U')


groups<- c()
color_vec<-c()
for (l in LETTERS){
  if(isVowel(l)){
    groups<-c(groups, 'v')
    color_vec<-c(color_vec, 'red')
  }
  else{
    groups <- c(groups, 'c')
    color_vec<- c(color_vec, 'black')
  } 
}
groups  
color_vec

cs1 = make_col_scheme(chars=LETTERS, 
                      groups=groups,
                      cols=color_vec)




# plot probability logo for all words and save as SVG
dev.off()
svg('plots/plogo-all10541.svg')
ggseqlogo(w$word, method='p', namespace=LETTERS, col_scheme=cs1) 
dev.off()

# plot probability logo for top 5000 words and save as SVG
svg('plots/plogo-top5000.svg')
ggseqlogo(w5$word, method='p', namespace=LETTERS, col_scheme=cs1)
dev.off()

dev.off()
svg('plots/bitlogo-all10541.svg')
ggseqlogo(w$word, namespace=LETTERS,  col_scheme=cs1)
dev.off()

dev.off()
svg('plots/bitlogo-top5000.svg')
ggseqlogo(w5$word, namespace=LETTERS,  col_scheme=cs1)
dev.off()





