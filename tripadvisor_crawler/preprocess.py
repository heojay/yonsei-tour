import pandas as pd
import gensim
from gensim.utils import simple_preprocess
from gensim.parsing.preprocessing import STOPWORDS
from nltk.stem import WordNetLemmatizer, SnowballStemmer
from nltk.stem.porter import *
import pickle
import nltk
nltk.download('wordnet')
stemmer = PorterStemmer()

def lemmatize_stemming(text):
    return stemmer.stem(WordNetLemmatizer().lemmatize(text, pos='v'))

def preprocess(text):
    result = []
    for token in gensim.utils.simple_preprocess(text):
        if token not in gensim.parsing.preprocessing.STOPWORDS and len(token) > 3:
            result.append(lemmatize_stemming(token))
    return result

starts_doc = [
    'Bukchon_Hanok_Village-Seoul',
    'Changdeokgung_Palace-Seoul',
    'Gyeongbokgung_Palace-Seoul',
    'Insadong-Seoul',
    'Kwangjang_Market-Seoul',
    'Myeongdong_Shopping_Street-Seoul',
    'The_War_Memorial_of_Korea-Seoul'
]

for doc in starts_doc:
    df = pd.read_csv(doc+'.csv')
    pre_review = df['review_body'].map(preprocess)

    dictionary = gensim.corpora.Dictionary(pre_review)
    dictionary.filter_extremes(no_below=15, no_above=0.5, keep_n=100000)

    bow_corpus = [dictionary.doc2bow(doc) for doc in pre_review]

    with open('pre_'+doc+'.txt', 'wb') as f:
        pickle.dump([dictionary, bow_corpus], f)

'''
Load는 다음과 같이 하면 됩니다.
with open('pre_Gyeongbokgung_Palace-Seoul.txt', 'rb') as f:
    dictionary, bow_corpus = pickle.load(f)
'''