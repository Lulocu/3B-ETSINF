#!/usr/bin/env python
#! -*- encoding: utf8 -*-
# 3.- Mono Library

import pickle
import random
import re
import sys

## Nombres: Luis López Cuerva Marc Rodas Lorente

########################################################################
########################################################################
###                                                                  ###
###  Todos los métodos y funciones que se añadan deben documentarse  ###
###                                                                  ###
########################################################################
########################################################################
#Documentar los métodos
#pickle con dump guarda un fochero en disco en binario
#en tri la clave son las dos primeras palabras
#Para trigramas la primera palabra desde bigrama
#
#
#
#
#
#
#
#
#
#
#
def sort_index(d):
    for k in d:
        l = sorted(((y, x) for x, y in d[k].items()), reverse=True)
        d[k] = (sum(x for x, _ in l), l)


class Monkey():

    def __init__(self):
        self.r1 = re.compile('[.;?!]')
        self.r2 = re.compile('\W+')

    def index_sentence(self, sentence, tri):
        """
        Este método indexa las palabras de la frase que recibe en bigramas y si tri es cierto también en trigramas

        :param 
            sentence: la frase que  recibe
            tri: booleano, indica si se deben indexar trigramas
        :return: None
        """
        #limpar caracteres
        sentence = self.r2.sub(' ',sentence) #sentence.replace(self.r2, '')
        sentence.lower()
        sentence = '$ ' + sentence + ' $'
        #spliteamos por espacio
        palabras = sentence.split()
        for j in range(len(palabras) - 1):
            clave = self.index['bi'].get(palabras[j])
            if clave is None:
                self.index['bi'][palabras[j]] = { palabras[j+1]: 1}      
            else:
                self.index['bi'][palabras[j]][palabras[j+1]] = self.index['bi'][palabras[j]].get(palabras[j+1], 0) + 1   
        if tri:
            for j in range(len(palabras) - 2):
                clave = self.index['tri'].get((palabras[j],palabras[j+1]))
                if clave is None:
                    self.index['tri'][(palabras[j],palabras[j+1])] = { palabras[j+2]: 1}      
                else:
                    self.index['tri'][(palabras[j], palabras[j+1])][palabras[j+2]] = self.index['tri'][(palabras[j],palabras[j+1])].get( palabras[j+2], 0) + 1 
                    
        #############
        #limpia caracteres quita simbolos raros
        #splitea
        #guarda estadisticas
        # COMPLETAR #
        #############
        pass


    def compute_index(self, filename, tri):
        """
        Este método separa el archivo en frases y llama a index sentence para indexar las frases

        :param 
            filename: nombre del archivo que  recibe
            tri: booleano, indica si se deben indexar trigramas
        :return: None
        """
        #procesar texto aquí
        self.index = {'name': filename, "bi": {}}
        if tri:
            self.index["tri"] = {}
        #raw_sentence = "" #puede ser innecesario

        with open(filename,'r',encoding="utf8") as fh:
            
            texto = fh.read()
            texto = texto.replace('\n\n', '.')
            frases = self.r1.sub('.',texto).split('.')
            for i in range(len(frases)):
                self.index_sentence(frases[i],tri)
            pass
        #extraer cada frase y llamar a index sentence
        #############
        #abrir fichero
        #extraer frases del fichero
        #para cada frase llamar a index
        # COMPLETAR #
        #############
        sort_index(self.index['bi'])
        if tri:
            sort_index(self.index['tri'])
        

    def load_index(self, filename):
        with open(filename, "rb") as fh:
            self.index = pickle.load(fh)
 

    def save_index(self, filename):
        with open(filename, "wb") as fh:
            pickle.dump(self.index, fh)


    def save_info(self, filename):
        with open(filename, "w") as fh:
            print("#" * 20, file=fh)
            print("#" + "INFO".center(18) + "#", file=fh)
            print("#" * 20, file=fh)
            print("filename: '%s'\n" % self.index['name'], file=fh)
            print("#" * 20, file=fh)
            print("#" + "BIGRAMS".center(18) + "#", file=fh)
            print("#" * 20, file=fh)
            for word in sorted(self.index['bi'].keys()):
                wl = self.index['bi'][word]
                print("%s\t=>\t%d\t=>\t%s" % (word, wl[0], ' '.join(["%s:%s" % (x[1], x[0]) for x in wl[1]])), file=fh)
            if 'tri' in self.index:
                print(file=fh)
                print("#" * 20, file=fh)
                print("#" + "TRIGRAMS".center(18) + "#", file=fh)
                print("#" * 20, file=fh)
                for word in sorted(self.index['tri'].keys()):
                    wl = self.index['tri'][word]
                    print("%s\t=>\t%d\t=>\t%s" % (word, wl[0], ' '.join(["%s:%s" % (x[1], x[0]) for x in wl[1]])), file=fh)


    def generate_sentences(self, n=10):

        """
        Este método genera frases al azar en el estilo del índice cargado

        :param 
            n: int, numero de frases a generar
        :return: None
        """
        for i in range(10):
            if self.index.get('tri') is None:
                lista = ['$']
                listaElec = []
                wl = self.index['bi']['$']
                i = 0
                for x, y in wl[1]:
                    for aux in range(x):
                            listaElec = listaElec + [y]
                lista = lista + [random.choice(listaElec)]
                n = 2

            
                while n < 24 and y not in '$':
                    wl = self.index['bi'][y]
                    n = n + 1
    
                    for x, y in wl[1]:
                        for aux in range(x):
                            listaElec = listaElec + [y]
                    lista = lista + [random.choice(listaElec)]
                lista = lista + ['$']

            else:
                lista = ['$']
                listaElec = []
                wl = self.index['bi']['$']
                i = 0
                encontrado = False
                while not encontrado:
                    for x, y in wl[1]:
                        for aux in range(x):
                            listaElec = listaElec + [y]
                    if self.index['tri'].get((lista[0], random.choice(listaElec)),None) is not None:
                        lista = lista + [random.choice(listaElec)]
                        n = 2
                        y = ('$', y)
                        encontrado = True
                
                while n < 24 and str(y) not in '$':
                    wl = self.index['tri'].get(y,None)

                    n = n + 1
                    if wl is not None:    
                        for x, y in wl[1]:
                            for aux in range(x):
                                listaElec = listaElec + [y]
                   
                        lista = lista + [random.choice(listaElec)]

                lista = lista + ['$']                
            print(' '.join(lista))
            
        #############
        # COMPLETAR #
        #############
        pass #borrar

if __name__ == "__main__":
    print("Este fichero es una librería, no se puede ejecutar directamente")


