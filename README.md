# RE2017_28
FIR filtar korišćenjem simetrije


Potrebno je napraviti filtar niskih u£estanosti. Projektovani filtar propušta niske učestanosti
do frekvencije fg=5kHz, dok na visokim učestanostima slabi signal 80dB. Ulazni signal
je dat u pcm formatu, a koeficijenti filtra su izračunati i nalaze se u fajlu fir.txt. Koeficijenti
FIR filtra se mogu na početku programa kao konstantni niz.
Potrebno je napraviti program koji filtrira ulazni signal u pcm formatu korišćenjem FIR filtra
čiji su koeficijenti dati u fajlu fir.txt. Inicijalizovati signalni bafer u koji će biti smešteno L/2
odbiraka ulaznog signala.

Nakon završetka čitanja ulaznog fajla, potrebno je generisati izlazni fajl u kome se nalaze
odbirci izlaznog signala y[n] u pcm formatu. Nazvati izlazni fajl kao ulazni *_out.pcm, gde je *
ime ulaznog fajla (npr. ako je ulazni fajl ime.pcm, izlazni je ime_out.pcm).
Rezultat izvršavanja programa verifikovati na fajlu input.pcm tako što će se pokretanjem
skripte u MATLAB-u compare.m prikazati rezultati filtriranja u MATLAB-u sa rezultatima
filtriranja korišćenjem realizovanog programa. Dati dijagrami bi trebalo da se slažu.
Izmeriti vreme izvržavanja programa.

Više na: http://tnt.etf.bg.ac.rs/~oe3re/Projekti/Projekti_2017.pdf
