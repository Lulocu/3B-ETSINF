#!/usr/bin/env python
#! -*- encoding: utf8 -*-

#Autores: Luis López  Cuerva
# 1.- Pig Latin
#diff para comparar
import sys
import re


class Translator():


    def __init__(self, punt=None):
        """
        Constructor de la clase Translator

        :param punt(opcional): una cadena con los signos de puntuación
                                que se deben respetar
        :return: el objeto de tipo Translator
        """
        if punt is None:
            self.re = re.compile("(\w+)([.,;?!]*)")
        else:
            self.re = re.compile("(\w+)(["+punt+"]*)")

    def translate_word(self, word):
        """
        Este método recibe una palabra en inglés y la traduce a Pig Latin

        :param word: la palabra que se debe pasar a Pig Latin
        :return: la palabra traducida
        """

        #sustituir
        #new_word = word
        #isupper -> todo mayus?
        #word[0].isupper() empieza mayus?
        #wordc = word[0].upper + word[1:].lower() palabra empieza por mayus
        #empieza vocal if word[0] in "aeiouy"
        mayusIni = False
        mayusTodo = False
        simbolo = False

        if not esLetra(word[0]):
            return word
        if word.isupper():
            mayusTodo = True
        elif word[0].isupper():
            mayusIni = True
            word = word[0].lower() + word[1:].lower()
        if word[-1] == self.re:
            final = word[-1]
            word = word[:-1]
            simbolo = True


        if not esVocal(word[0]):
            for letra in word[1:]:
                if not esVocal(word[0]):
                    word = word[1:] + word[0]
                else:
                    break
            #mirar si empiezaconsonante
            new_word = word + 'ay'
        else:
            new_word = word + 'yay'

        if mayusTodo:
            new_word = new_word.upper()
        if mayusIni:
            new_word = new_word[0].upper() + new_word[1:]
        if simbolo:
            new_word = new_word + final
        #newWord, symbol = 
        return new_word

    def translate_sentence(self, sentence):
        """
        Este método recibe una frase en inglés y la traduce a Pig Latin

        :param sentence: la frase que se debe pasar a Pig Latin
        :return: la frase traducida
        """

        # sustituir
        # new_sentence = sentence
        traducciones = []
        for word, signo in self.re.findall(sentence): #sentence.split():
            newWord = self.translate_word(word)
            traducciones.append(newWord + signo)
        new_sentence = ' '.join(traducciones)
        return new_sentence

    def translate_file(self, filename):
        """
        Este método recibe un fichero y crea otro con su tradución a Pig Latin

        :param filename: el nombre del fichero que se debe traducir
        :return: True / False 
        """
        #manejador = open(fichero,modo), para crear igual modo escritura (w)
        #iterador sobre el manejador

        fh = open(filename)
        fh2 = open('Traduccion.res','w')
        for line in fh:
            linia = self.translate_sentence(line) + '\n'
            fh2.write(linia)
        fh2.close()
        fh.close()

        # rellenar
def esVocal(l):
    return l in 'aeiouyAEIOUY'
def esLetra(l):
    return l in 'qwertyuiopasdfghjklñzxcvbnmçQWERTYUIOPASDFGHJKLÑÇZXCVBNM'


if __name__ == "__main__":
    if len(sys.argv) > 2:
        print('Syntax: python %s [filename]' % sys.argv[0])
        exit
    else:
        t = Translator()
        if len(sys.argv) == 2:
            t.translate_file(sys.argv[1])
        else:
            while True:
                sentence = input("ENGLISH: ")
                if len(sentence) < 2:
                    break
                print("PIG LATIN:", t.translate_sentence(sentence))
