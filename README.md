# Predgovor

Navodila so napisana izključno v slovenskem jeziku. Predvsem iz razloga, da mladim približam odprto kodni svet ter radioamaterstvo.
Celotna vsebino je prosta in ni avtorsko zaščitena.

Vsi postopki, ki so predstavljeni in opisani v nadaljevanju so bili preverjeni tako na fizičnem kot na virtualnem računalniku z [OS Debian 10.2](https://www.debian.org/)

Vesel bom vsake povratne informacije.

# O vsebini

V nadaljevanju vam bom pokazal, kako na OS Debian uspešno namestiti in nastaviti program N1MM Logger Plus.  

Vsebina je v osnovi povzeta iz strani [https://www.scivision.co/n1mm-logger-linux-wine/](https://www.scivision.co/n1mm-logger-linux-wine/)

Ampak avtor je pri tem imel v mislih, da program namešča napredni uporabnik Linux sistem. Tukaj sem poskušal napisati navodila, da lahko program uspšeno namesti tudi začetnik v Linux sitemu.

# O programu N1MM Logger Plus

Omenjeni program radioamaterji uporabljamo za beleženje radijskih zvez v času tekmovanj ali kot osebni dnevnik zvez, katerega smo dolžni obvezno voditi in ga hraniti 5 let (minimalno). Dnevnik lahko vodimo, kot radi rečemo analogno (pišemo v zvezek) ali digitalno. Pri digitalnem arhiviranju je potrebno povdarit dve zadevi in sicer:
- arhiv mora biti lahko in hitro dostopen
- prav tako ni izgovora, če nam disk ali ključek prenehata delovat - tako da potrebno je izvajat varnostne kopije baz ali dokumentov.

# Pred namestitvijo

Predhodno je potrebno na Debian namestiti program git. V primeru, da je že nameščen git nas bo program apt o tem obvestil.

Torej odpremo terminal in vnesemo ukaz

```bash
sudo apt install -y git
```

# Namestitev ...
## ... z git
V konzolo vnesemo naslednje zaporedje ukazov
```bash
cd ~

git clone https://github.com/s50ts/n1mmLoggerPlus.git

cd n1mmLoggerPlus

chmod +x install.sh

./install.sh
```

Ko uspešno namestimo je potrebno še prebrati poglavje **Nastavitve za komunikacijo z radijsko postajo**

## ... v korakih

Naj prej si za čas seje shranimo koren lokacije od koder izvajam skripto
```bash
KOREN=$PWD
```
Posodobimo repositorije ter nadgradimo pakete, katere je potrebno.
```bash
sudo apt update

sudo apt upgrade
```

Namestimo program apt-get-repository
```bash
sudo apt install -y software-properties-common
```

Omogočimo podporo za 32-bitno arhitekturo
```bash
sudo dpkg --add-architecture i386
```

### Namestitev WineHQ

Dodamo GPG ključ
```bash
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
```
kot rezultat moremo dobiti **OK**.

Dodamo WineHQ repositorij na seznam.
```bash
sudo apt-add-repository https://dl.winehq.org/wine-builds/debian/

sudo apt update
```

Sedaj namestimo zadnjo stabilno verzijo WineHQ.
```bash
sudo apt install -y winehq-stable
```

V domači direktorji dodamo še winetricks
```bash
cd ~

wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
```

ter omogočimo izvajanje
```bash
chmod +x winetricks
```

### Namestitev N1MM Logger+

Nastavimo da Wine deluje pod Windows 7, ter za 32-bitno arhitekturo
```bash
WINEPREFIX=~/.wine_n1mm WINEARCH=win32 winecfg
```
V oknu, katero se nam odpre izberemo samo OK

Za delovanje programa N1MM Logger v Wine potrebujemo .NET 4.0.
Namestitev lahko traja med 3 do 5 min odvisno kako zmogljiv računalnik imamo.
Med namestitvijo se lahko nam zgodi, da se bo okno prenehalo odzivat, ampak v
konzoli bo vse potekalo naprej.
```bash
WINEPREFIX=~/.wine_n1mm ~/winetricks dotnet40
```

Sedaj namestimo N1MM logger. Zadnjo verzijo lahko prenesemo iz strani [https://n1mmwp.hamdocs.com/downloads/n1mm-full-install/](https://n1mmwp.hamdocs.com/downloads/n1mm-full-install/) ali pa uporabimo to, katera je priložena. Če prenesemo novo verzijo, potem je potrebno priloženo verzijo programa odstranit.
```bash
WINEPREFIX=~/.wine_n1mm wine $KOREN/N1MM*FullInstaller*.exe
```

Namestimo še popravke in posodobitve za N1MM Logger. Zadnje verzijo posodobitev lahko prenesemo iz strani [https://n1mmwp.hamdocs.com/mmfiles/categories/programlatestupdate/](https://n1mmwp.hamdocs.com/mmfiles/categories/programlatestupdate/) ali uporabimo te, katere so priloženi. Če prenesemo novo verzijo popravkov, potem je potrebno priložene popravke odstranit.
```bash
WINEPREFIX=~/.wine_n1mm wine $KOREN/N1MM*Update*.exe
```

Po namestitvi se nam bo samodejno prikazala ikon za zagon programa N1MM Logger+. V primeru, da želimo zagnati nameščeni program iz konzole potem, si lahko skopiramo skripto **n1mm.sh** v domači direktorji.

```bash
cp $KOREN/n1mm.sh ~/n1mm.sh
```

Ter dodamo še pravice za izvajanje
```bash
chmod +x ~/n1mm.sh
```

Za zagon programa v konzolo enostavno zapišemo
```bash
~/n1mm.sh
```

# Nastavitve za komunikacijo z radijsko postajo

Program opcijsko omogoča (seveda postaja mora omogočati), da ga povežemo z radijsko postajo. Za to potrebujemo pretvornik iz USB na serijska vrata. Za to nalogo je najboljše uporabiti vmesnik, kateri uporablja čip FT232R. Omenjeni čip je dobro podprt v vseh znanih OS (Linux, macOS in Windows).

Ko priklopimo USB vmesnik odpremo terminal in vnesemo
```bash
sudo dmesg -w
```
S tem preverimo ali nam je OS res zaznal naš vmesnik.

Sedaj je potrebno samo še narediti preslikavo iz **/dev/ttyUSB0** na **COM1**.
Zaženemo program **regedit**
```bash
WINEPREFIX=~/.wine_n1mm wine regedit
```
Ter uredimo
```
HKEY_LOCAL_MACHINE\Software\Wine\Ports
```
tako da dodamo novo spremenljivko tipa niz (string). Ime spremenljivke nastavimo na **COM1** ter vrednost **/dev/ttyUSB0**.

Resetiramo Wine
```bash
wineserver -k
```

Zaženemo program
```bash
~/n1mm.sh
```

Preverimo nastavitve
```bash
ls ~/.wine_n1mm/dosdevices/com1
```
sedaj bi nam moral **COM1** se preslikati v **/dev/ttyUSB0**
