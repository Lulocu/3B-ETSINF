#! -*- encoding: utf8 -*-



## Nombres: 
#Luis Lopez Cuerva
#Marc Rodas Lorente
########################################################################
########################################################################
###                                                                  ###
###  Todos los métodos y funciones que se añadan deben documentarse  ###
###                                                                  ###
########################################################################
########################################################################

import argparse
import re
import sys

import operator

def sort_dic_by_values(d, asc=True):
    return sorted(d.items(), key=lambda a: (-a[1], a[0]))

class WordCounter:

    def __init__(self):
        """
           Constructor de la clase WordCounter
        """
        self.clean_re = re.compile('\W+')

    def write_stats(self, filename, stats, use_stopwords, full):
        """
        Este método escribe en fichero las estadísticas de un texto
            

        :param 
            filename: el nombre del fichero destino.
            stats: las estadísticas del texto.
            use_stopwords: booleano, si se han utilizado stopwords
            full: boolean, si se deben mostrar las stats completas

        :return: None
        """
        with open(filename, 'w') as fh:
            ## completar
            fh.write('Lines: ' + str(stats.get("nlines",0)) + '\n')
            fh.write('Number words (including stopwords): ' + str(stats.get("nwords",0) + stats.get("nstop",0)) + '\n')
            if use_stopwords:
                fh.write('Number words (without stopwords): ' + str(stats.get("nwords",0)) + '\n')
            fh.write('Vocabulary size: ' + str(len(stats.get("word",{}))) + '\n')
            fh.write('Number of symbols: ' + str(stats.get("nsymbol",0)) + '\n')
            fh.write('Number of different symbols: '  + str(len(stats.get("symbol",{}))) + '\n')
            fh.write('Words (alphabetical order):\n')
            
            stats['word'] = sorted(stats['word'].items())
            i = 0
            for clave in stats["word"]:                
                fh.write('\t' + clave[0] +': ' + str(clave[1]) + '\n')
                i = i + 1
                if full == False and i >=20: 
                    break
            pass

            fh.write('Words (by frequency):\n')
            
            stats['word'] = sorted(stats['word'], key=operator.itemgetter(1), reverse=True)
         
            i = 0
            for clave in stats["word"]:                
                fh.write('\t' + clave[0] +': ' + str(clave[1]) + '\n')
                i = i + 1
                if full == False and i >=20: 
                    break
            pass

            fh.write('Symbols (alphabetical order):\n')
            
            stats['symbol'] = sorted(stats['symbol'].items())
            i = 0
            for clave in stats["symbol"]:                
                fh.write('\t' + clave[0] +': ' + str(clave[1]) + '\n')
                i = i + 1
                if full == False and i >=20: 
                    break
            pass

            fh.write('Symbols (by frequency):\n')
            
            stats['symbol'] = sorted(stats['symbol'], key=operator.itemgetter(1), reverse=True)
         
            i = 0
            for clave in stats["symbol"]:                
                fh.write('\t' + clave[0] +': ' + str(clave[1]) + '\n')
                i = i + 1
                if full == False and i >=20: 
                    break
            pass


#################################################bigramas2###############################
            if args.bigram:
                fh.write('Word pairs (alphabetical order):\n')
            
                stats['biword'] = sorted(stats['biword'].items())
                i = 0
                for clave in stats["biword"]:                
                    fh.write('\t' + clave[0] +': ' + str(clave[1]) + '\n')
                    i = i + 1
                    if full == False and i >=20: 
                        break
                pass

                fh.write('Word pairs (by frequency):\n')
                
                stats['biword'] = sorted(stats['biword'], key=operator.itemgetter(1), reverse=True)

                i = 0
                for clave in stats["biword"]:                
                    fh.write('\t' + clave[0] +': ' + str(clave[1]) + '\n')
                    i = i + 1
                    if full == False and i >=20: 
                        break
                pass

                fh.write('Symbol pairs (alphabetical order):\n')
                
                stats['bisymbol'] = sorted(stats['bisymbol'].items())
                i = 0
                for clave in stats["bisymbol"]:                
                    fh.write('\t' + clave[0].replace(' ','') +': ' + str(clave[1]) + '\n')
                    i = i + 1
                    if full == False and i >=20: 
                        break
                pass

                fh.write('Symbol pairs (by frequency):\n')
                
                stats['bisymbol'] = sorted(stats['bisymbol'], key=operator.itemgetter(1), reverse=True)

                i = 0
                for clave in stats["bisymbol"]:                
                    fh.write('\t' + clave[0].replace(' ','') +': ' + str(clave[1]) + '\n')
                    i = i + 1
                    if full == False and i >=20: 
                        break
            pass






    def file_stats(self, filename, lower, stopwordsfile, bigrams, full):
        """
        Este método calcula las estadísticas de un fichero de texto
            

        :param 
            filename: el nombre del fichero.
            lower: booleano, se debe pasar todo a minúsculas?
            stopwordsfile: nombre del fichero con las stopwords o None si no se aplican
            bigram: booleano, se deben calcular bigramas?
            full: booleano, se deben montrar la estadísticas completas?

        :return: None
        """

        stopwords = [] if stopwordsfile is None else open(stopwordsfile).read().split()

        # variables for results
        barra = True
        sts = {
                'nwords': 0,
                'nlines': 0,
                'word': {},
                'symbol': {},
                'nsymbol':0,
                'nstop':0
                }

        if bigrams:
            sts['biword'] = {}
            sts['bisymbol'] = {}
        
        with open(filename,'r') as f:
            for line in f:
                sts["nlines"] = sts.get("nlines",0) + 1
                if(lower):
                    line = line.lower()
                line = self.clean_re.sub(' ',line)
                words = line.split()
                for l in range(len(words)):
                    if words[l] not in stopwords:
                        sts["nwords"] = sts.get("nwords",0) + 1
                        sts["word"][words[l]] = sts["word"].get(words[l], 0) + 1
                        for symbol in words[l]:
                            sts["nsymbol"] = sts.get("nsymbol",0) + 1
                            sts["symbol"][symbol] = sts["symbol"].get(symbol,0) + 1
                    else:
                        sts["nstop"] = sts.get("nstop",0) + 1
        pass   
        # completar
        with open(filename,'r') as f:
            if bigrams:
                
                for line in f:
                    line = self.clean_re.sub(' ',line)
                    if len(line) > 1:
                        line = '$ ' + line + '$'
                    if(lower):
                        line = line.lower()
                    for w in range(len(stopwords)):
                        line = re.sub(" " + stopwords[s] + " ")
                    words = line.split()
                    
                    for l in range(len(words) - 1):
                        if words[l] not in stopwords and words[l+1] not in stopwords:
                            
                            clave1,clave2 = words[l:l+2]# + ' ' + words[l+1]
                            sts["biword"][clave1 + ' ' + clave2] = sts["biword"].get(clave1 + ' ' + clave2, 0) + 1
                            #sts['biword'][(w1,w2)] = sts['biword'].get((w1,w2), 0) + 1
                            for symbol in range(len(words[l]) -1):
                        
                                algo = words[l][symbol]
                                algo2 = words[l][symbol + 1]
                                sts["bisymbol"][algo  + ' ' + algo2] = sts["bisymbol"].get(algo + ' ' + algo2,0) + 1
                            

        pass

        filename,extension = filename.split('.')
        new_filename = filename + '_'
        if lower:
            new_filename = new_filename + 'l'
            barra = False
        if stopwords:
            new_filename = new_filename + 's'
            barra = False
        if bigrams:
            new_filename = new_filename + 'b'
            barra = False
        if full:
            new_filename = new_filename + 'f'
            barra = False
        if not barra:
            new_filename = new_filename + '_'
        new_filename = new_filename + 'stats.' + extension 
        self.write_stats(new_filename, sts, stopwordsfile is not None, full)


    def compute_files(self, filenames, **args):
        """
        Este método calcula las estadísticas de una lista de ficheros de texto
            

        :param 
            filenames: lista con los nombre de los ficheros.
            args: argumentos que se pasan a "file_stats".

        :return: None
        """

        for filename in filenames:
            self.file_stats(filename, **args)

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Compute some statistics from text files.')
    parser.add_argument('file', metavar='file', type=str, nargs='+',
                        help='text file.')

    parser.add_argument('-l', '--lower', dest='lower', action='store_true', default=False, 
                    help='lowercase all words before computing stats.')

    parser.add_argument('-s', '--stop', dest='stopwords', action='store',
                    help='filename with the stopwords.')

    parser.add_argument('-b', '--bigram', dest='bigram', action='store_true', default=False, 
                    help='compute bigram stats.')

    parser.add_argument('-f', '--full', dest='full', action='store_true', default=False, 
                    help='show full stats.')

    args = parser.parse_args()
    wc = WordCounter()
    wc.compute_files(args.file, lower=args.lower, stopwordsfile=args.stopwords, bigrams=args.bigram, full=args.full)