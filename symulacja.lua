


LOSOW=1000
SKALA_LICZB=15
LOSOWANYCH_LICZB=3
KOSZT_LOSU=50

math.randomseed( os.time() )

local function obliczStawke(losow)
  -- @todo przenoszenie niewygranej stawki z poprzedniego losowania
  local stawka=losow*KOSZT_LOSU*0.50
  stawka=math.max(stawka, KOSZT_LOSU*10)
  return stawka
end

local function wylosujLiczby(ile,skala)
  local liczby={}
  -- losowanie
  while (#liczby<ile) do
    local liczba=math.random(1, skala)
    local alreadyin=false
    for i=1,#liczby do
      if liczby[i]==liczba then alreadyin=true end
    end
    if not alreadyin then
      table.insert(liczby, liczba)
    end
  end
  -- sortowanie
  table.sort(liczby)

  return liczby
end

local function policzTrafienia(tl, tw)
  -- sprawdza ile liczb w tabeli tl znajduje sie w tabeli tw
  local ile=0
  for _,los in ipairs(tl) do
    for _,cel in ipairs(tw) do
      if los==cel then ile=ile+1 end
    end
  end
  return ile
end

-- logika symulacji -------------------------------

stawka=obliczStawke(LOSOW)

losy={}

for i=1,LOSOW do
  table.insert(losy, wylosujLiczby(LOSOWANYCH_LICZB, SKALA_LICZB))
end

print("Stawka do wygrania w losowaniu: "..stawka)
print("Udział wzięło osób: "..LOSOW)
suma_wplat=LOSOW*KOSZT_LOSU

print("Łącznie wplat: ".. suma_wplat)

wygrywajaceLiczby=wylosujLiczby(LOSOWANYCH_LICZB, SKALA_LICZB)
print("Wylosowane liczby: ".. table.concat( wygrywajaceLiczby, ", "))

local pule={}

-- szukamy zwyciezcow
for i=1,#losy do
  local trafien=policzTrafienia(losy[i], wygrywajaceLiczby)
  --  print(string.format("Los %d trafien %d", i, trafien))
  pule[trafien]=(pule[trafien] or 0) + 1
  --if trafien==2 then
  --  print("Trafiona 2-ka: " .. table.concat(losy[i], ", "))
  --end
end

-- podsumowanie:
local suma_wyplat=0
for i=LOSOWANYCH_LICZB,1,-1 do
  print ("Trafionych "..i.."-ek: ".. (pule[i] or 0))
  if (pule[i] or 0)>0 and i==3 then
    local suma=stawka
    suma_wyplat=suma_wyplat+suma
    print("Wyplacono " .. suma_wyplat)
    -- @todo ktory los wygral
    local suma_pp=stawka/pule[i]
    print("Per osoba: " .. suma_pp)
  end

  if (pule[i] or 0)>0 and i==2 then
    local suma=KOSZT_LOSU*5*pule[i]
    print("Wyplacono ".. suma)
    suma_wyplat=suma_wyplat+suma
    -- @todo ktory los wygral
    local suma_pp=KOSZT_LOSU*5
    print("Per osoba: ".. suma_pp)
  end

end


print("Sumarycznie wyplacono: " .. suma_wyplat)
