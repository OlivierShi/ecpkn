from nltk.corpus import stopwords
import string

def del_punk(filename=None):
    stop = stopwords.words('english')
    punc = string.punctuation
    with open(filename, 'r') as f:
        docs = f.readlines()
    new_doc = []
    for line in docs:
        new_line = []
        for w in line.strip().split():
            if w in stop or w in punc:
                continue
            new_line.append(w)
        new_doc.append(' '.join(new_line))
    return '\n'.join(new_doc)


def build_dict(filenames):
    vocab = []
    for filename in filenames:
        d = {}
        # del stopwords and punks
        text = del_punk(filename)
        for line in text.split('\n'):
            for w in line.split():
                if w in d:
                    d[w] += 1
                else:
                    d[w] = 1
        vocab.append(d)
    full_vocab = vocab[0].copy()
    full_vocab.update(vocab[1])
    # print len(vocab[0])  # 13938
    # print len(vocab[1])  # 14383
    # print len(full_vocab)  # 21282
    return full_vocab


def chi2feature():
    pos_f = "token_pos"
    neg_f = "token_neg"
    vocab = build_dict([pos_f, neg_f])
    pos_docs = del_punk(pos_f)
    pos_docs = pos_docs.split('\n')
    neg_docs = del_punk(neg_f)
    neg_docs = neg_docs.split('\n')
    n = len(pos_docs)
    N = 2 * n

    score_dict = {}
    for w in vocab:
        A = 0.
        B = 0.
        for line in pos_docs:
            words = line.split()
            if w in words:
                A += 1
        for line in neg_docs:
            words = line.split()
            if w in words:
                B += 1
        C = n - A
        D = n - B
        score_dict[w] = float(N) * (A*D - B*C) * (A*D - B*C) /(A+C)/(A+B)/(B+D)/(B+C)
    return score_dict












if __name__ == "__main__":
    # del_punk('token_pos')
    build_dict(['token_pos', 'token_neg'])
