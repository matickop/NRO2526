# DN2 – INTERPOLACIJA

`Točka: (0.403, 0.503)`  

Metode:
1. scatteredInterpolant – najpočasnejša zaradi triangulacije(nad 1.4M) veliko točk, čas ki je bil potreben je bil čez 4 sekunde.  

2. griddedInterpolant – mnogo hitrejša kot prejšna(scatteredInterpolant). Default in metoda ki sem jo znotraj funkcije
klical je bilinearna kot naslednja funkcija, ki sem jo sam spisal.  

3. Bilinearna - Izracun indeksa celice preko podane enacbe. Vrednost oziroma rešitev(temperatura), je ista kot pri
griddedInterpolant funkciji z klicanjem "linear". Vendar je moja se vedno malo pocasneja, oziroma v pakratnem 
testiranju programa je nekajkrat prišla tudi na prvo mesto.  



Najhitrejša: Nekajkrat je najhitrejša bila bilinearna, večinokrat pa griddedInterpolant. Sicer pa sta obedve isti metodi,
le da je bilinear spisana iz moje strani, griddedInterpolant pa je ze v matlab - je verjetno bolj optimizirana.  

Bonus: dodal sem še “nearest neighbor”, samo za primerjavo, ki pa je mnogokrat prišla
na prvo mesto v času, sicer je glede na točnost rešitve še najmanj točna, saj ne napenja funkcije med točkami ampak samo
skače do druge točke(stopničasto), je pa zato toliko hitrejša.