drop table if exists users;
drop table if exists race;
drop table if exists race_dispute;
drop table if exists driver;
drop table if exists retire;
drop table if exists news;
drop table if exists comments;
drop view if exists drivers_teams_standings;

create table users (
  title varchar(10) not null,
  firstName varchar(100) not null,
  lastName varchar(100) not null,
  country varchar(100) not null,
  birthDate date not null,
  username varchar(255) unique not null,
  email varchar(255) primary key not null,
  password varchar(256) not null,
  dateIns timestamp default current_timestamp not null,
  journalist char(1) check(journalist in('t', 'f', 'T', 'F'))
);

create table race (
  race_date date primary key,
  race_name varchar(80) not null,
  expected_laps number(2,0) not null,
  completed_laps number(2,0) not null,
  scheduled_race_time char(5) not null,
  race_start_time char(5),
  race_end_time char(5),
  race_type varchar(15) not null check (
    race_type in ('sprint', 'completa', 'Sprint', 'Completa','SPRINT','COMPLETA')
  ),
  medical_car varchar(30) not null,
  safety_car varchar(30) not null,
  card_number char(10) not null,
  nome_sponsor varchar(50),
  circuit_name varchar(50) not null,
	driver_number number(2,0),
	constraint check_sprint_giro check ((race_type <> 'sprint' and race_type <> 'Sprint' and race_type <> 'SPRINT') or
	(race_type = 'sprint' and driver_number is null) or (race_type = 'Sprint' and driver_number is null) or
	(race_type = 'SPRINT' and driver_number is null)),
  constraint fk_medical_car_race foreign key (medical_car) references Medical_Car (marca_MC) on delete cascade,
	constraint fk_safety_car_race foreign key (safety_car) references Safety_Car (marca_SC) on delete cascade,
  constraint fk_director_race foreign key (card_number) references Direttore (fk_medical_car_race) on delete cascade,
  constraint fk_sponsor_race foreign key (nome_sponsor) references Sponsor (nome_sponsor) on delete set null,
  constraint fk_circuit_race foreign key (circuit_name) references Circuito (nome_circuito) on delete cascade,
	constraint fk_driver_race foreign key (driver_number) references driver (driver_number) on delete set null
);

create table race_dispute (
  race_date date,
  driver_number number(2,0),
  final_race_position number(2,0) not null check (final_race_position >= 1 and final_race_position <= 20),
  constraint pk_race_dispute primary key (race_date,driver_number),
	constraint uniq_race_pos unique (race_date,final_race_position),
	constraint fk_race_race_dispute foreign key (race_date) references race (race_date) on delete cascade,
  constraint fk_driver_race_dispute foreign key (driver_number) references driver (driver_number) on delete cascade
);

create table retire (
  race_date date,
  driver_number number(2,0),
  lap varchar(2) not null,
  cause varchar(30) not null check (
		cause in ('guasto','Guasto','GUASTO','incidente','Incidente','INCIDENTE')
  ),
	constraint pk_retire primary key (race_date,driver_number),
  constraint fk_race_retire foreign key (race_date) references race (race_date) on delete cascade,
  constraint fk_driver_retire foreign key (driver_number) references driver (driver_number) on delete cascade
);

create table driver (
  driver_number number(2,0) primary key check (driver_number >= 1 and driver_number <= 99),
  driver_first_name varchar(50) not null,
  driver_last_name varchar(50) not null,
  driver_nation varchar(30),
  team_name varchar(30) not null,
  constraint fk_scuderia_driver foreign key (team_name) references Scuderia (nome_scuderia) on delete cascade
);

create table comments (
  id integer primary key autoincrement,
  author varchar(255) not null,
  news_id integer not null,
  comment_title varchar(255) not null,
  comment_text text not null,
  date_insert timestamp default current_timestamp not null,
  constraint fk_comment_news foreign key (news_id) references news (id) on delete cascade,
  constraint fk_comment_user foreign key (author) references users (username) on delete cascade
);

create table news (
  id integer primary key autoincrement,
  news_title text(255) not null,
  news_subtitle text(255) not null,
  news_text text not null,
  news_img_src varchar(30) not null,
  news_img_alt varchar(30) not null
);

-- news
insert into news (news_title, news_subtitle, news_text, news_img_src, news_img_alt)
values (
    "Kings of Leon to headline the 2024 British Grand Prix's opening concert", 
    "Silverstone has announced that Kings of Leon will headline the
    2024 British Grand Prix’s iconic Opening Concert on Thursday, July
    4, 2024.",
    "Having attracted record crowds of 480,000 people this summer,
      Silverstone is set to go bigger and better in 2024 - with Stormzy
      (Friday), Pete Tong Presents Ibiza Classics (Saturday) and
      Rudimental (Sunday) already announced for the exciting four-day
      festival taking place across the Grand Prix weekend.

      Recognised as one of the biggest alternative rock bands on the
      planet, Kings of Leon have been awarded multiple Grammys and BRIT
      Awards and have headlined the biggest and most prestigious music
      festivals in the world, including Coachella, Glastonbury, Roskilde
      and Lollapalooza. Since their debut in 2003, the Nashville rockers
      have sold over 20 million albums and nearly 40 million singles
      worldwide.

      Fans flocked to Silverstone’s newly-expanded music arena
      throughout the 2023 British Grand Prix to be entertained by a
      stellar line up of artists such as Calvin Harris, Tom Grennan, Cat
      Burns, Jess Glynne, Black Eyed Peas and Jax Jones. For 2024,
      ticket holders will once again enjoy four gigantic evenings of
      live music and entertainment at no extra cost.

      «We are incredibly excited to have global icons Kings of Leon join
      our line-up for the 2024 British Grand Prix», said Silverstone's
      Commercial Director Nick Read.

      «Our long-term ambition has always been to attract the biggest and
      best artists in the world to Silverstone to put on a spectacular
      show for the British fans. With Kings of Leon now joining Stormzy, Rudimental and Pete Tong on next year’s line-up, it’s fair to say the 2024 British Grand Prix is going to be bigger and better than ever before!»",
    "https://images.radiox.co.uk/images/59032?width=1548&crop=1_1&signature=x4sJxlWxwadyYPBdXGBEjiy2UmY=",
    "Kings of Leon"
);
insert into news (news_title, news_subtitle, news_text, news_img_src, news_img_alt)
values (
    "«Why am I so unlucky?» - Leclerc left devastated by formation lap failure in Brazil", 
    "It wasn’t to be for Charles Leclerc in Brazil, the Ferrari driver
    suffering a mechanical failure on the formation lap that ultimately
    took him out of the race.",
    "Initially, as he spun off into the barriers when following eventual race-winner Max Verstappen around Interlagos, it looked like Leclerc might recover back to the pits and be able to start the race - but he soon parked up down an escape road with an engine issue to go with his broken front wing and wounded pride.

    It's been a desperate season for Ferrari, who had hoped to challenge Red Bull for the title, as they did in the early stages of last year. Instead, they have a handful of poles and just the one race win to their name for 2023, and that was achieved by Leclerc’s team mate in Singapore.

    For the Monegasque, this latest failure was another blow in what has been an incredibly tough season. Starting from second on the grid and one of the few front runners still to have some fresh soft tyres in his locker, he had hoped to have a strong race. Instead, it all unravelled before the lights had even gone out.

    «I turned into Turn 6, everything was fine and then as you can see, I basically lose the wheel because there is no power steering anymore, the steering wheel feels extremely stiff, then I go
    straight», he said afterwards.

    «Then the engine stopped for safety reasons, which made the rear wheels lock, which made me spin. Then I touched the wall, I started
    to start the car again, I did 20 metres then exactly the same thing
    happened. So that’s it.»

    Leclerc’s anguish was clear to see, the Monegasque driver holding
    his head in his hands in the cockpit. «Why the **** am I so unlucky, why the **** am I so unlucky?» he repeated down the radio to his race engineer, before climbing out of his cockpit and sitting on the wall, head bowed.

    «I don’t know, I don’t know, I don’t know what to do anymore», he
    said when he spoke to the media while the race was still continuing.          

    «It’s been a season to forget, there’s been quite a few races where
    I felt I was on it and then for some reason or other, it wasn’t the
    result I wanted on Sunday and today is part of them, so of course,
    the frustration is big today.»

    «It’s like this now, I need to get over it and focus on the last two races which are still important. I cannot wait [for] it to be next year.»

    In the fight for second in the constructors’, Carlos Sainz did at
    least out-score Mercedes in the race by coming home sixth ahead of
    Lewis Hamilton in eighth, which means Ferrari trail the Silver
    Arrows by 20 points going into the final two races of the season.",
    "https://i.redd.it/0bsjmkvaoxyb1.jpg",
    "Devastated Leclerc"
);
insert into news (news_title, news_subtitle, news_text, news_img_src, news_img_alt)
values (
    "Lambiase reveals his 'biggest fear' about Verstappen relationship
          going forward", 
    "Max Verstappen and his race engineer Gianpiero Lambiase have forged
            a formidable partnership during their time together at Red Bull -
            but the journey to title-winning glory has not been without some
            bumps in the road.", 
    "Verstappen and Lambiase joined forces a handful of races into the
            2016 season, when the Dutch teenager was promoted to Red Bull in
            place of Daniil Kvyat and spectacularly won on his debut for the
            team at the Spanish Grand Prix.

            After several seasons of watching on as Mercedes wrapped up
            back-to-back titles, Verstappen and Red Bull finally emerged as
            championship contenders in 2021, narrowly beating Lewis Hamilton to
            that year’s crown before storming clear in 2022 and 2023.

            However, despite the recent dominance under F1’s latest ground
            effect era, Verstappen and Lambiase have been involved in several
            heated radio exchanges in recent times, prompting plenty of
            questions from the media about their relationship.

            Appearing together on Red Bull’s Talking Bull podcast, Verstappen
            and Lambiase tackled the topic head on, with the latter serving up
            an amusing comment to kick things off.

            «My biggest fear is the moment that we do have increased competition
            and we’re not winning every race, because you see how he’s treating
            me at the moment - and he’s winning every race!» Lambiase smiled,
            also prompting a laugh from Verstappen.

            Offering a more serious take on the situation as the conversation
            developed, Verstappen argued that «something is wrong» if there are
            not occasional moments of frustration in his and Lambiase’s quest
            for success.

            «I mean, I still get upset, even in such a dominant season, when
            things don’t go well, and it’s the same for GP», he commented.

            «We still want to win, we still want to do everything as perfect as
            we can, even though no one is perfect, but we try to be as close to
            perfection as possible. That’s why sometimes, of course, we still
            have our arguments, but it’s all because we are very driven to
            win...

            «When we come out of the weekend, we say how we could have done
            things better, or quite a bit better. You know, it still upsets us,
            which I think is good because if you don’t have that drive, then I
            think something is wrong.»

            Given how much they have already achieved together, Lambiase and
            Verstappen also opened up about the key factors behind their
            successful working relationship on and off the track.

            «I don’t think it’s a real secret, but you just need to get on
            really well, you need to understand what you want from each other»,
            explained Verstappen.

            «I think nowadays, we really grew in our role as well I guess, but I
            almost don’t need to even say anything… After I say I have a bit of
            understeer or oversteer, GP knows what he will change on the car for
            me, the way I drive the car as well, and that takes time.

            «That’s why I would always be against changing race engineers or
            performance engineers - they’re very crucial in your performance.
            The longer you can stay together, the better, because you will
            really be one and one.»

            Describing Verstappen as his «little brother», Lambiase added:«I
            think what’s really important is just to be able to be yourself. I
            think Max feels he can be himself with me, I can be myself around
            him, and there’s no tiptoeing around any issues at all.

            «If we have to be blunt about something with each other, we will be,
            and I think that just fast-tracks you to short-term gains, which
            ultimately is maximising the potential of the car during a race
            weekend.»",
    "https://sportsbase.io/images/gpfans/copy_1200x800/4af3b21d901c5f4085ae8fb4c04695b68a724ca1.jpg",
    "Gianpiero Lambiase"
);
insert into news (news_title, news_subtitle, news_text, news_img_src, news_img_alt)
values (
    "Stewards to consider Haas 'Right of Review' request over US Grand Prix
          result", 
    "United States Grand Prix stewards are to consider a request from the
            Haas team for a Right of Review of the Austin race results in
            relation to track limit infringements, including those by Williams’
            Alex Albon.",
    "Albon, who finished in ninth place at the Circuit of The Americas,
            was reported to the stewards during the race for allegedly leaving
            the track without a justifiable reason multiple times in Turn 6.
            However, no further action was taken as it was deemed there was
            insufficient proof.

            «Based on the video footage available (which did not include CCTV),
            the Stewards determine, whilst there might be some indication for
            possible track limit infringements in Turn 6, the evidence at hand
            is not sufficient to accurately and consistently conclude that any
            breaches occurred», read the stewards’ document at the time.

            Now, a two-part hearing will commence on Wednesday, with the first
            part to hear evidence as to whether there is a «significant and
            relevant new element which was unavailable to the party seeking the
            Review at the time of the Decision concerned.»

            Should the stewards determine that such an element exists, a second
            part of the hearing will be convened at a later date. As well as
            Haas and Williams, Red Bull and Aston Martin have also been called
            to attend the hearing.

            Haas driver Nico Hulkenberg narrowly missed out on the points in
            Austin. After the disqualifications of Charles Leclerc and Lewis
            Hamilton, the German was classified 11th, having taken the flag less
            than two seconds behind the second Williams of Logan Sargeant.

            With two rounds of the season remaining, Haas lie 10th and last in
            the constructors’ championship on 12 points, four behind
            ninth-placed Alfa Romeo.",
    "https://cdn.racingnews365.com/2023/Hulkenberg/_1125x633_crop_center-center_85_none/XPB_1246392_HiRes.jpg?v=1699120887",
    "Haas' car on track"
);
insert into news (news_title, news_subtitle, news_text, news_img_src, news_img_alt)
values (
    "'Close to perfect weekend' for Norris as he grabs fifth podium in six race",
    "While he didn’t manage to put too much pressure on Max Verstappen
    for the race lead, Norris kept the Dutchman honest throughout and
    snatched his fifth podium from the last six races, or his seventh
    top-three if you include the Sprints.",
    "There have been occasional errors during those events which Norris
    has been up front about, which is why it was good to see the smiling
    Briton concede that on balance, this weekend was pretty good.

    «This has been a close to perfect weekend, close, not quite, but as
    close as it gets», he said afterwards. «I just got a very good
    start, I did the opposite of yesterday. I mean that saved me, I
    don’t know what happened to [Leclerc], I saw he had an issue which
    was a shame as it would have been good to try and race everyone a
    little bit.

    «But at the same time, the less people I can race the better. Yeah,
    to start and get into P2 I was like “ohhh we can have a tasty one
    here with Max”. I tried on my first opportunity, but I only had one
    and I couldn’t make it count. Again, like I said yesterday, it’s
    very positive to be up there, fighting in these positions, to have
    such a big gap to everyone behind us.»

    After the second big raft of upgrades bolted onto Norris’ car in
    Singapore jumped McLaren up the order, with the team delivering
    strong showings in Japan, Qatar and Austin, the last two races in
    Mexico City and Sao Paulo were expected to reshuffle the order
    somewhat.

    «The pace has been very strong, yeah, to be coming into a race
    weekend where we weren’t expecting to be performing quite at this
    level, I think is a very good surprise for us», continued Norris.

    «Here and Mexico are the two tracks we said we were going to
    struggle, and we’ve come out of them a lot better than we were
    expecting so I think it’s a big positive for the whole team and for
    myself to know this. It doesn’t seem like there are any bad tracks
    for us at the minute.»

    With Norris just three points behind Fernando Alonso in the fightfor
    fourth in the drivers’ championship, there’s still plenty to play
    for in the last two races of the season - as he continues to hunt
    that elusive first Grand Prix victory. But he remained well aware
    that the next race in Las Vegas could either be a huge opportunity
    or a huge bump back down to earth, calling it a «question mark» for
    everyone.

    He's knocking down the door of a win, but as he said himself when he
    crossed the line in Sao Paulo, there’s “always that one car in the
    way.”",
    "https://preview.redd.it/lando-norris-mclaren-lift-his-2nd-place-trophy-race-2023-v0-3582q5fhrryb1.jpg?auto=webp&s=b7701b91af8aaf5bc46f7343ff78653f68625d20",
    "Lando Norris lift his 2nd place trophy"
);
insert into news (news_title, news_subtitle, news_text, news_img_src, news_img_alt)
values (
    "Perez found “intense” battle with Alonso “super enjoyable” despite
          missing out on the podium", 
    "Sergio Perez missed out on a top three finish in Sao Paulo by just
            0.053s, as Fernando Alonso pipped him in a drag race across the
            finishing line. It was the perfect end to an epic battle that had
            been going on for many laps between the Red Bull and the Aston
            Martin.",
    "Lap 48 was when Perez first found himself directly behind the Aston
            Martin on track, but it took a few laps for the Mexican to close the
            gap with both drivers on soft tyres for their final stint. Alonso
            had the advantage of having pitted one lap later for fresh rubber,
            Perez having bolted on three-lap old softs at his final stop.

            It took until Lap 54 for Perez to get into DRS range of Alonso
            ahead, and the Mexican soon went for a move into Turn 1. But Alonso
            knew he was coming and took a wider line to cut back across the
            apex, preventing his rival from squeezing down the inside. That was
            the status quo for lap after lap, Perez harrying and Alonso
            defending for all he was worth.

            But on the penultimate lap, the Mexican finally found a way past
            into Turn 1, and managed to almost break the DRS to ensure Alonso
            couldn’t return the favour into Turn 4. The Spaniard admitted that
            he thought his chance of a podium had gone, only for Perez to brake
            a fraction too late into Turn 1 on the final lap, giving Alonso a
            run into Turn 4 where he retook the position.

            The two then had a drag race across the line, Alonso shading it by
            the barest of margins.
          
            “I mean it was a great fight with Fernando, I don’t think with a lot
            of drivers you can do these kinds of manoeuvers,” Perez said
            afterwards. “It was really tight from beginning to end, it was super
            enjoyable to be honest, I did have a lot of fun. In the end he ended
            up getting the podium, but it is how the sport is.

            “I think we had a great fight, very fair and to the limit. I think
            this is something a lot of drivers can learn from, what we did, the
            way we fight today, I think it’s something – it’s how it should be
            done. I’m in the wrong side, I ended up losing but it’s fine because
            it was a great fight.”

            Perez’s wait for a first podium since Monza continues, but he did
            finish in the top three in Saturday’s Sprint and was able to fully
            extract the pace from the RB19 in what was a fairly successful
            weekend for the Mexican – which gave him plenty to be pleased with.

            “We’ve seen in the last couple of races that the pace has been
            there, that we’ve been really strong but for some reason or another,
            we haven’t been able to get the end result. But I just knew it was a
            matter of time.”

            Team boss Christian Horner called it “a big drive” when he radioed
            his congratulations after Perez took the flag, saying his driver
            “gave it everything.”

            With Lewis Hamilton struggling, Perez has increased his advantage in
            the fight for second in the drivers’ championship, with Red Bull
            never having managed a 1-2 finish in their history.",
    "https://www.f1sport.it/wp-content/uploads/2023/11/c.webp",
    "Perez and Alonso's battle"
);
insert into news (news_title, news_subtitle, news_text, news_img_src, news_img_alt)
values (
    "‘Inexcusable performance’ – Wolff brands Mercedes’ W14 ‘miserable’ as
          car ‘doesn’t deserve a win’", 
    "Toto Wolff has labelled Mercedes’ W14 “miserable” following an
    “inexcusable performance” at the Sao Paulo Grand Prix.",
    "After successive runner-up finishes at the last two Grands Prix –
            albeit with his Austin P2 result later resulting in disqualification
            – Lewis Hamilton could only claim a lowly P8 in Brazil, while team
            mate George Russell was forced to retire.

          Hamilton had lined up fifth for the race, and made a great start to
            find himself running third in the early stages, but he soon dropped
            to fourth following the restart – after Alex Albon and Kevin
            Magnussen’s crash – when Fernando Alonso passed him.

          That downward trajectory continued for the seven-time world
            champion, with Sergio Perez overtaking him a few laps later. In the
            end eighth was as good as it got, with Lance Stroll, Carlos Sainz
            and Pierre Gasly all finishing ahead in what was a bitter blow
            following recent green shoots of optimism.

          Though Russell was forced to retire on lap 59 of the race, his pace
            had also been faltering through the Grand Prix, and Team Principal
            Wolff summed up the mood at Mercedes with a damning assessment of
            the team’s 2023 car.

          “Inexcusable performance,” he told Sky Sports following the race.
            “There’s not even words for that. That car finished second last
            week, and the week before, and whatever we did to it was horrible.”

          “Lewis survived out there but George… I can only feel for the two
            driving such a miserable thing. It shows how difficult the car is,
            it’s on a knife edge.”

          “We’ve got to develop that better for next year because it can’t be
            that within seven days you’re finishing on the podium – solid, one
            of the two quickest cars – and then we finish eighth.”

          With the inquest sure to begin rapidly as to why the W14 was so off
            the pace out in Brazil, Wolff and everyone else will be desperate to
            understand the reasons behind its inconsistency – particularly with
            the 2024 season rapidly approaching.

          “Yeah, we’re clearly not world champions on Sprint race weekends, we
            do some good work here on track to get it done but still it doesn’t
            explain what went wrong,” Wolff said when asked if the Sprint format
            might be a factor. “That car almost drove like it was on three
            wheels and not on four.”

          There is also little love lost towards this season’s Mercedes
            machinery. While last year’s troublesome W13 managed one victory
            during the season at Interlagos, Wolff was in no doubt as to whether
            the team’s 2023 offering deserved a Grand Prix victory to its name.

          “This car doesn’t deserve a win,” he said. “We need to push for the
            last two races and recover. I think that’s the most important thing
            and see what we can do in Las Vegas – a totally different track –
            and Abu Dhabi. But the performance today was… I’m just lacking
            words.”

          He added: “I think straight-line speed was one issue but probably
            not the main factor [in Brazil]. The main factor was that we
            couldn’t go around the corners with the bigger wing, with the pace
            we needed, and we were killing the tyres – just eating them up
            within a few laps.”

          With just two races remaining of the 2023 campaign, many of the
            learnings made at this stage will help to inform Mercedes of where
            they are in the hope of challenging Red Bull next year.

          There’s also the matter of securing P2 in the constructors’
            championship, with Ferrari 20 points behind them in third, though
            Mercedes were undoubtedly aided by Charles Leclerc being unable to
            start the Grand Prix after spinning out on the formation lap in Sao
            Paulo.

          Hamilton’s bid for P2 in the drivers’ standings also lost momentum
            with Sergio Perez’s P4 in Brazil extending the gap. The Red Bull man
            now leads Hamilton by 32 points with the constructor’s champions
            hoping to seal their first ever 1-2 in the drivers’ championship.",
    "https://www.f1sport.it/wp-content/uploads/2020/06/F1-Wolff-Mercedes-Fotocattagni-o3pth4z8o1rrgi5n3fnlk8gzbi8iqj8oqpgrmlmhog-1200x799-1.jpg",
    "Toto Wolff"
);
insert into news (news_title, news_subtitle, news_text, news_img_src, news_img_alt)
values (
    "Winners and Losers from Sao Paulo – Who left Interlagos the happiest
          in the final Sprint weekend of the season?", 
    "Max Verstappen extended his record of most wins in a season to 17.
            But while there was joy for the Dutchman, there was frustration for
            others, not least those caught up in the opening lap melee.",
    "Winner: Max Verstappen - There is just no stopping the Dutchman in 2023. He grabbed the win
            in Saturday’s Sprint, and then dominated from pole in the Grand Prix
            to chalk up an incredible 17th win out of the 20 races so far this
            year.

          Having long since wrapped up the title, he’s showing no signs of
            taking his foot off the gas – much to the dismay of the rest. He
            nailed the two standing starts in the Grand Prix, and only conceded
            the lead once during the second pit stop period.

          His 52nd career win moved him into fourth and past Alain Prost in
            the all-time list, and the way he’s driving, you’d be hard-pressed
            to bet against him recording more victories with two races to go.

          Loser: Charles Leclerc - 
          What does Charles Leclerc have to do to get a sliver of luck this
            season? He had qualified well and was due to start second on the
            grid, one of the few front runners to have a fresh set of softs to
            play with. But disaster struck before the race even started,
            technical issues causing him to spin out on the Formation Lap.

          The Monegasque driver cut a disconsolate figure as first he put his
            head in his hands, before lamenting on the radio as to why he was
            “so ******* unlucky.” He then sat on the barriers, totally downcast
            before finally making his way back to the Ferrari racege.

          It’s the second time he hasn’t scored in the last three races, to
            add to his disqualification from Austin. It would be a very, very
            small consolation that he did at least pick up a few points in the
            Sprint.

          Winner: Lando Norris - 
          Lando Norris has been left a tad frustrated with some small mistakes
            in qualifying at the last few race weekends, and wasn’t too happy
            with his starting slot for Sunday’s Grand Prix. But he put that
            right by grabbing pole for the Sprint, coming home second after
            acknowledging that he didn’t have the pace to fight Verstappen.

          On Sunday, a brilliant start from sixth on the grid launched him up
            to second, where he was the only driver able to stay within touching
            distance of the lead Red Bull. It might not be the win he so craves,
            but a fifth podium in six Grands Prix and another Driver of the Day
            accolade is still a pretty handy return.

          Losers: Mercedes -
          Mercedes performed strongly in Brazil last year, and many favoured
            them to do likewise, believing this was their best chance of a
            victory this season. But their pace was non-existent in the Sprint,
            with both Lewis Hamilton and George Russell struggling with tyre
            wear.

          They had hoped to rectify that for the Grand Prix, but suffered the
            same issues on Sunday. Both drivers found themselves going
            backwards, with reliability also an issue for George Russell, who
            retired with ‘high and worsening PU oil temperatures.’

          Hamilton eventually came home eighth, after complaining that he
            couldn’t keep up with Pierre Gasly’s Alpineeven with the help of
            DRS. He joked afterwards that he was looking forward to never
            driving the W14 again, while Toto Wolff went further, branding the
            race an “inexcusable performance.”

          Winners: Aston Martin - After a late-season slump that saw their speed completely disappear,
            not to mention reliability concerns rear up, Aston Martin were back
            on form in Brazil. They abandoned the upgraded floor that caused
            them so many difficulties in Austin to lock-out the second row of
            the grid for the Grand Prix.

          Both Fernando Alonso and Lance Stroll drove superb races to come
            home third and fifth, but it was the Spaniard’s late, incredible
            defence against the Red Bull of Sergio Perez that was the highlight
            of the weekend for the team in green.

          Alonso took his first podium since Zandvoort and eighth of the
            season by a hair’s breadth from the Red Bull, after retaking third
            place on the very last lap. It was the sort of drive that will be
            remembered for a long time, and shows that age is no barrier to
            performance for the veteran world champion.

          Loser: Alex Albon -
          Alex Albon made a great getaway from 13th on the grid, one of the
            best of anyone he believed at the time. He was on the cusp of the
            points paying positions, but found himself the innocent bystander as
            Nico Hulkenberg tagged his rear, sending him careering into the
            sister Haas of Kevin Magnussen.

          He crashed heavily, and as well as a hefty repair bill likely to hit
            Williams hard so close to the end of the season, there were no
            points for the team on a day where Albon felt he had the pace for
            the top 10.

          Winner: Yuki Tsunoda -
          Yuki Tsunoda put some Friday qualifying frustrations to one side by
            grabbing sixth on the gridfor the Sprint and converting that into
            more points for AlphaTauri. But he did even better on Sunday,
            climbing back through the field on a day the car obviously had
            decent pace to secure ninth at the flag.

          His five-point haul from the weekend reduces the gap to Williams to
            just seven-points in the fight for seventh in the constructors’, an
            incredible turnaround for the team who had been rock bottom of the
            standings all season until Mexico. And with Daniel Ricciardo also
            saying his car had great pace, AlphaTauri must feel confident of
            running Williams pretty close with just two races to go.

          Losers: Alfa Romeo - 
          Alfa Romeo went into the weekend confident of a good result at a
            track where Valtteri Bottas has done well at in the past. But
            instead, they recorded their first double DNF of the season on
            Sunday, as they left with no points for the third race weekend in a
            row.

          The team would only say it was a technical issue that caused the
            retirements, confirming it was not the same issue on both cars.
            Having lost so much ground to AlphaTauri in the constructors’
            championship, they can ill afford reliability issues this late in
            the season.
",
    "https://saltwire.imgix.net/2023/11/5/motor-racing-verstappen-wins-in-sao-paulo-for-17th-win-of-th_uMeMDQ7.jpg?cs=srgb&fit=crop&h=568&w=847&dpr=1&auto=format%2Cenhance%2Ccompress",
    "Verstappen's Red Bull on track"
);

-- driver
insert into driver values (77,'Valtteri','Bottas','Finlandia','Alfa Romeo');
insert into driver values (24,'Guanyu','Zhou','Cina','Alfa Romeo');
insert into driver values (88,'Robert','Kubica','Polonia','Alfa Romeo');
insert into driver values (98,'Theo','Pourchaire','Francia','Alfa Romeo');
insert into driver values (10,'Pierre','Gasly','Francia','AlphaTauri');
insert into driver values (22,'Yuki','Tsunoda','Giappone','AlphaTauri');
insert into driver values (40,'Liam','Lawson','Nuova Zelanda','AlphaTauri');
insert into driver values (14,'Fernando','Alonso','Spagna','Alpine');
insert into driver values (31,'Esteban','Ocon','Francia','Alpine');
insert into driver values (82,'Jack','Doohan','Australia','Alpine');
insert into driver values (18,'Lance','Stroll','Canada','Aston Martin');
insert into driver values (5,'Sebastian','Vettel','Germania','Aston Martin');
insert into driver values (27,'Nico','Hulkenberg','Germania','Aston Martin');
insert into driver values (34,'Felipe','Drugovich','Brasile','Aston Martin');
insert into driver values (16,'Charles','Leclerc','Monaco','Ferrari');
insert into driver values (55,'Carlos','Sainz Jr.','Spagna','Ferrari');
insert into driver values (39,'Robert','Shwartzman','Russia','Ferrari');
insert into driver values (20,'Kevin','Magnussen','Danimarca','Haas');
insert into driver values (47,'Mick','Schumacher','Germania','Haas');
insert into driver values (99,'Antonio','Giovinazzi','Italia','Haas');
insert into driver values (51,'Pietro','Fittipaldi','Brasile','Haas');
insert into driver values (3,'Daniel','Ricciardo','Australia','McLaren');
insert into driver values (4,'Lando','Norris','Regno Unito','McLaren');
insert into driver values (28,'Alex','Palou','Spagna','McLaren');
insert into driver values (29,'Patricio','O''Ward','Messico','McLaren');
insert into driver values (44,'Lewis','Hamilton','Regno Unito','Mercedes');
insert into driver values (63,'George','Russell','Regno Unito','Mercedes');
insert into driver values (1,'Max','Verstappen','Olanda','Red Bull Racing');
insert into driver values (11,'Sergio','Perez','Messico','Red Bull Racing');
insert into driver values (36,'Juri','Vips','Estonia','Red Bull Racing');
insert into driver values (23,'Alexander','Albon','Thailandia','Williams Racing');
insert into driver values (45,'Nyck','De Vries','Olanda','Williams Racing'); 
insert into driver values (6,'Nicholas','Latifi','Canada','Williams Racing');
insert into driver values (46,'Logan','Sargeant','Stati Uniti','Williams Racing');

-- race
insert into race values ('20-MAR-2022','Bahrain Grand Prix',57,57,'18:00','18:00','19:37','Completa','Mercedes','Mercedes','0193000032','Gulf Air','Bahrain International Circuit',16);
insert into race values ('27-MAR-2022','Saudi Arabian Grand Prix',50,50,'20:00','20:00','21:24','Completa','Mercedes','Mercedes','0193000032','STC','Jeddah Corniche Circuit',16);
insert into race values ('10-APR-2022','Australian Grand Prix',58,58,'15:00','15:00','16:27','Completa','Aston Martin','Aston Martin','0193000032','Heineken','Albert Park Circuit',16);
insert into race values ('23-APR-2022','Gran Premio del Made in Italy e dell''Emilia Romagna',21,21,'16:30','16:30','17:00','Sprint','Aston Martin','Aston Martin','0193000032','Rolex','Autodromo Enzo e Dino Ferrari',NULL);
insert into race values ('24-APR-2022','Gran Premio del Made in Italy e dell''Emilia Romagna',63,63,'15:00','15:00','16:32','Completa','Aston Martin','Aston Martin','0193000032','Rolex','Autodromo Enzo e Dino Ferrari',1);
insert into race values ('08-MAY-2022','Miami Grand Prix',57,57,'15:30','15:30','17:04','Completa','Mercedes','Mercedes','0193000032','Crypto.com','Miami International Autodrome',1);
insert into race values ('22-MAY-2022','Gran Premio de Espana',66,66,'15:00','15:00','16:37','Completa','Aston Martin','Aston Martin','0193000033','Pirelli','Circuit de Barcelona-Catalunya',11);
insert into race values ('29-MAY-2022','Grand Prix de Monaco',78,64,'15:00','15:00','16:56','Completa','Mercedes','Mercedes','0193000033',NULL,'Circuit de Monaco',4);
insert into race values ('12-JUN-2022','Azerbaijan Grand Prix',51,51,'15:00','15:00','16:34','Completa','Mercedes','Mercedes','0193000032',NULL,'Baku City Circuit',11);
insert into race values ('19-JUN-2022','Grand Prix du Canada',70,70,'14:00','14:00','15:36','Completa','Mercedes','Mercedes','0193000033','AWS','Circuit Gilles Villeneuve',55);
insert into race values ('03-JUL-2022','British Grand Prix',52,52,'15:00','15:00','17:17','Completa','Aston Martin','Aston Martin','0193000032','Lenovo','Silverstone Circuit',44);
insert into race values ('09-JUL-2022','Grosser Preis von Osterreich',23,23,'16:30','16:30','16:56','Sprint','Aston Martin','Aston Martin','0193000032','Rolex','Red Bull Ring',NULL);
insert into race values ('10-JUL-2022','Grosser Preis von Osterreich',71,71,'15:00','15:00','16:24','Completa','Aston Martin','Aston Martin','0193000032','Rolex','Red Bull Ring',1);
insert into race values ('24-JUL-2022','Grand Prix de France',53,53,'15:00','15:00','16:30','Completa','Mercedes','Mercedes','0193000033','Lenovo','Circuit Paul Ricard',55);
insert into race values ('31-JUL-2022','Magyar Nagydij',70,70,'15:00','15:00','16:39','Completa','Aston Martin','Aston Martin','0193000033','Aramco','Hungaroring',44);
insert into race values ('28-AUG-2022','Belgian Grand Prix',44,44,'15:00','15:00','16:25','Completa','Mercedes','Mercedes','0193000032','Rolex','Circuit de Spa-Francorchamps',1);
insert into race values ('04-SEP-2022','Dutch Grand Prix',72,72,'15:00','15:00','16:36','Completa','Mercedes','Mercedes','0193000033','Heineken','Circuit Zandvoort',1);
insert into race values ('11-SEP-2022','Gran Premio d''Italia',53,53,'15:00','15:00','16:20','Completa','Aston Martin','Aston Martin','0193000032','Pirelli','Autodromo nazionale di Monza',11);
insert into race values ('02-OCT-2022','Singapore Grand Prix',61,59,'20:00','20:00','22:02','Completa','Mercedes','Mercedes','0193000033','Singapore Airlines','Marina Bay Street Circuit',63);
insert into race values ('09-OCT-2022','Japanese Grand Prix',53,28,'14:00','14:00','17:01','Completa','Mercedes','Mercedes','0193000033','Honda','Suzuka International Racing Course',24);
insert into race values ('23-OCT-2022','United States Grand Prix',56,56,'14:00','14:00','15:42','Completa','Aston Martin','Aston Martin','0193000032','Aramco','Circuit of the Americas',63);
insert into race values ('30-OCT-2022','Gran Premio de la Ciudad de Mexico',71,71,'14:00','14:00','15:38','Completa','Aston Martin','Aston Martin','0193000032',NULL,'Autodromo Hermanos Rodriguez',63);
insert into race values ('12-NOV-2022','Grande Premio de Sao Paulo',24,24,'15:30','15:30','16:00','Sprint','Aston Martin','Aston Martin','0193000032','Heineken','Autodromo Jose Carlos Pace',NULL);
insert into race values ('13-NOV-2022','Grande Premio de Sao Paulo',71,71,'15:00','15:00','16:38','Completa','Aston Martin','Aston Martin','0193000032','Heineken','Autodromo Jose Carlos Pace',63);
insert into race values ('20-NOV-2022','Abu Dhabi Grand Prix',58,58,'17:00','17:00','18:27','Completa','Mercedes','Mercedes','0193000032','Etihad Airways','Yas Marina Circuit',4);

-- race_dispute
insert into race_dispute values ('20-MAR-2022',16,1);
insert into race_dispute values ('20-MAR-2022',55,2);
insert into race_dispute values ('20-MAR-2022',44,3);
insert into race_dispute values ('20-MAR-2022',63,4);
insert into race_dispute values ('20-MAR-2022',20,5);
insert into race_dispute values ('20-MAR-2022',77,6);
insert into race_dispute values ('20-MAR-2022',31,7);
insert into race_dispute values ('20-MAR-2022',22,8);
insert into race_dispute values ('20-MAR-2022',14,9);
insert into race_dispute values ('20-MAR-2022',24,10);
insert into race_dispute values ('20-MAR-2022',47,11);
insert into race_dispute values ('20-MAR-2022',18,12);
insert into race_dispute values ('20-MAR-2022',23,13);
insert into race_dispute values ('20-MAR-2022',3,14);
insert into race_dispute values ('20-MAR-2022',4,15);
insert into race_dispute values ('20-MAR-2022',6,16);
insert into race_dispute values ('20-MAR-2022',27,17);
insert into race_dispute values ('20-MAR-2022',11,18);
insert into race_dispute values ('20-MAR-2022',1,19);
insert into race_dispute values ('20-MAR-2022',10,20);

insert into race_dispute values ('27-MAR-2022',1,1);
insert into race_dispute values ('27-MAR-2022',16,2);
insert into race_dispute values ('27-MAR-2022',55,3);
insert into race_dispute values ('27-MAR-2022',11,4);
insert into race_dispute values ('27-MAR-2022',63,5);
insert into race_dispute values ('27-MAR-2022',31,6);
insert into race_dispute values ('27-MAR-2022',4,7);
insert into race_dispute values ('27-MAR-2022',10,8);
insert into race_dispute values ('27-MAR-2022',20,9);
insert into race_dispute values ('27-MAR-2022',44,10);
insert into race_dispute values ('27-MAR-2022',24,11);
insert into race_dispute values ('27-MAR-2022',27,12);
insert into race_dispute values ('27-MAR-2022',18,13);
insert into race_dispute values ('27-MAR-2022',23,14);
insert into race_dispute values ('27-MAR-2022',77,15);
insert into race_dispute values ('27-MAR-2022',14,16);
insert into race_dispute values ('27-MAR-2022',3,17);
insert into race_dispute values ('27-MAR-2022',6,18);
insert into race_dispute values ('27-MAR-2022',22,19);
insert into race_dispute values ('27-MAR-2022',47,20);

insert into race_dispute values ('10-APR-2022',16,1);
insert into race_dispute values ('10-APR-2022',11,2);
insert into race_dispute values ('10-APR-2022',63,3);
insert into race_dispute values ('10-APR-2022',44,4);
insert into race_dispute values ('10-APR-2022',4,5);
insert into race_dispute values ('10-APR-2022',3,6);
insert into race_dispute values ('10-APR-2022',31,7);
insert into race_dispute values ('10-APR-2022',77,8);
insert into race_dispute values ('10-APR-2022',10,9);
insert into race_dispute values ('10-APR-2022',23,10);
insert into race_dispute values ('10-APR-2022',24,11);
insert into race_dispute values ('10-APR-2022',18,12);
insert into race_dispute values ('10-APR-2022',47,13);
insert into race_dispute values ('10-APR-2022',20,14);
insert into race_dispute values ('10-APR-2022',22,15);
insert into race_dispute values ('10-APR-2022',6,16);
insert into race_dispute values ('10-APR-2022',14,17);
insert into race_dispute values ('10-APR-2022',1,18);
insert into race_dispute values ('10-APR-2022',5,19);
insert into race_dispute values ('10-APR-2022',55,20);

insert into race_dispute values ('23-APR-2022',1,1);
insert into race_dispute values ('23-APR-2022',16,2);
insert into race_dispute values ('23-APR-2022',11,3);
insert into race_dispute values ('23-APR-2022',55,4);
insert into race_dispute values ('23-APR-2022',4,5);
insert into race_dispute values ('23-APR-2022',3,6);
insert into race_dispute values ('23-APR-2022',77,7);
insert into race_dispute values ('23-APR-2022',20,8);
insert into race_dispute values ('23-APR-2022',14,9);
insert into race_dispute values ('23-APR-2022',47,10);
insert into race_dispute values ('23-APR-2022',63,11);
insert into race_dispute values ('23-APR-2022',22,12);
insert into race_dispute values ('23-APR-2022',5,13);
insert into race_dispute values ('23-APR-2022',44,14);
insert into race_dispute values ('23-APR-2022',18,15);
insert into race_dispute values ('23-APR-2022',31,16);
insert into race_dispute values ('23-APR-2022',10,17);
insert into race_dispute values ('23-APR-2022',23,18);
insert into race_dispute values ('23-APR-2022',6,19);
insert into race_dispute values ('23-APR-2022',24,20);

insert into race_dispute values ('24-APR-2022',1,1);
insert into race_dispute values ('24-APR-2022',11,2);
insert into race_dispute values ('24-APR-2022',4,3);
insert into race_dispute values ('24-APR-2022',63,4);
insert into race_dispute values ('24-APR-2022',77,5);
insert into race_dispute values ('24-APR-2022',16,6);
insert into race_dispute values ('24-APR-2022',22,7);
insert into race_dispute values ('24-APR-2022',5,8);
insert into race_dispute values ('24-APR-2022',20,9);
insert into race_dispute values ('24-APR-2022',18,10);
insert into race_dispute values ('24-APR-2022',23,11);
insert into race_dispute values ('24-APR-2022',10,12);
insert into race_dispute values ('24-APR-2022',44,13);
insert into race_dispute values ('24-APR-2022',31,14);
insert into race_dispute values ('24-APR-2022',24,15);
insert into race_dispute values ('24-APR-2022',6,16);
insert into race_dispute values ('24-APR-2022',47,17);
insert into race_dispute values ('24-APR-2022',3,18);
insert into race_dispute values ('24-APR-2022',14,19);
insert into race_dispute values ('24-APR-2022',55,20);

insert into race_dispute values ('08-MAY-2022',1,1);
insert into race_dispute values ('08-MAY-2022',16,2);
insert into race_dispute values ('08-MAY-2022',55,3);
insert into race_dispute values ('08-MAY-2022',11,4);
insert into race_dispute values ('08-MAY-2022',63,5);
insert into race_dispute values ('08-MAY-2022',44,6);
insert into race_dispute values ('08-MAY-2022',77,7);
insert into race_dispute values ('08-MAY-2022',31,8);
insert into race_dispute values ('08-MAY-2022',23,9);
insert into race_dispute values ('08-MAY-2022',18,10);
insert into race_dispute values ('08-MAY-2022',14,11);
insert into race_dispute values ('08-MAY-2022',22,12);
insert into race_dispute values ('08-MAY-2022',3,13);
insert into race_dispute values ('08-MAY-2022',6,14);
insert into race_dispute values ('08-MAY-2022',47,15);
insert into race_dispute values ('08-MAY-2022',20,16);
insert into race_dispute values ('08-MAY-2022',5,17);
insert into race_dispute values ('08-MAY-2022',10,18);
insert into race_dispute values ('08-MAY-2022',4,19);
insert into race_dispute values ('08-MAY-2022',24,20);

insert into race_dispute values ('22-MAY-2022',1,1);
insert into race_dispute values ('22-MAY-2022',11,2);
insert into race_dispute values ('22-MAY-2022',63,3);
insert into race_dispute values ('22-MAY-2022',55,4);
insert into race_dispute values ('22-MAY-2022',44,5);
insert into race_dispute values ('22-MAY-2022',77,6);
insert into race_dispute values ('22-MAY-2022',31,7);
insert into race_dispute values ('22-MAY-2022',4,8);
insert into race_dispute values ('22-MAY-2022',14,9);
insert into race_dispute values ('22-MAY-2022',22,10);
insert into race_dispute values ('22-MAY-2022',5,11);
insert into race_dispute values ('22-MAY-2022',3,12);
insert into race_dispute values ('22-MAY-2022',10,13);
insert into race_dispute values ('22-MAY-2022',47,14);
insert into race_dispute values ('22-MAY-2022',18,15);
insert into race_dispute values ('22-MAY-2022',6,16);
insert into race_dispute values ('22-MAY-2022',20,17);
insert into race_dispute values ('22-MAY-2022',23,18);
insert into race_dispute values ('22-MAY-2022',24,19);
insert into race_dispute values ('22-MAY-2022',16,20);

insert into race_dispute values ('29-MAY-2022',11,1);
insert into race_dispute values ('29-MAY-2022',55,2);
insert into race_dispute values ('29-MAY-2022',1,3);
insert into race_dispute values ('29-MAY-2022',16,4);
insert into race_dispute values ('29-MAY-2022',63,5);
insert into race_dispute values ('29-MAY-2022',4,6);
insert into race_dispute values ('29-MAY-2022',14,7);
insert into race_dispute values ('29-MAY-2022',44,8);
insert into race_dispute values ('29-MAY-2022',77,9);
insert into race_dispute values ('29-MAY-2022',5,10);
insert into race_dispute values ('29-MAY-2022',10,11);
insert into race_dispute values ('29-MAY-2022',31,12);
insert into race_dispute values ('29-MAY-2022',3,13);
insert into race_dispute values ('29-MAY-2022',18,14);
insert into race_dispute values ('29-MAY-2022',6,15);
insert into race_dispute values ('29-MAY-2022',24,16);
insert into race_dispute values ('29-MAY-2022',22,17);
insert into race_dispute values ('29-MAY-2022',23,18);
insert into race_dispute values ('29-MAY-2022',47,19);
insert into race_dispute values ('29-MAY-2022',20,20);

insert into race_dispute values ('12-JUN-2022',1,1);
insert into race_dispute values ('12-JUN-2022',11,2);
insert into race_dispute values ('12-JUN-2022',63,3);
insert into race_dispute values ('12-JUN-2022',44,4);
insert into race_dispute values ('12-JUN-2022',10,5);
insert into race_dispute values ('12-JUN-2022',5,6);
insert into race_dispute values ('12-JUN-2022',14,7);
insert into race_dispute values ('12-JUN-2022',3,8);
insert into race_dispute values ('12-JUN-2022',4,9);
insert into race_dispute values ('12-JUN-2022',31,10);
insert into race_dispute values ('12-JUN-2022',77,11);
insert into race_dispute values ('12-JUN-2022',23,12);
insert into race_dispute values ('12-JUN-2022',22,13);
insert into race_dispute values ('12-JUN-2022',47,14);
insert into race_dispute values ('12-JUN-2022',6,15);
insert into race_dispute values ('12-JUN-2022',18,16);
insert into race_dispute values ('12-JUN-2022',20,17);
insert into race_dispute values ('12-JUN-2022',24,18);
insert into race_dispute values ('12-JUN-2022',16,19);
insert into race_dispute values ('12-JUN-2022',55,20);

insert into race_dispute values ('19-JUN-2022',1,1);
insert into race_dispute values ('19-JUN-2022',55,2);
insert into race_dispute values ('19-JUN-2022',44,3);
insert into race_dispute values ('19-JUN-2022',63,4);
insert into race_dispute values ('19-JUN-2022',16,5);
insert into race_dispute values ('19-JUN-2022',31,6);
insert into race_dispute values ('19-JUN-2022',77,7);
insert into race_dispute values ('19-JUN-2022',24,8);
insert into race_dispute values ('19-JUN-2022',14,9);
insert into race_dispute values ('19-JUN-2022',18,10);
insert into race_dispute values ('19-JUN-2022',3,11);
insert into race_dispute values ('19-JUN-2022',5,12);
insert into race_dispute values ('19-JUN-2022',23,13);
insert into race_dispute values ('19-JUN-2022',10,14);
insert into race_dispute values ('19-JUN-2022',4,15);
insert into race_dispute values ('19-JUN-2022',6,16);
insert into race_dispute values ('19-JUN-2022',20,17);
insert into race_dispute values ('19-JUN-2022',22,18);
insert into race_dispute values ('19-JUN-2022',47,19);
insert into race_dispute values ('19-JUN-2022',11,20);

insert into race_dispute values ('03-JUL-2022',55,1);
insert into race_dispute values ('03-JUL-2022',11,2);
insert into race_dispute values ('03-JUL-2022',44,3);
insert into race_dispute values ('03-JUL-2022',16,4);
insert into race_dispute values ('03-JUL-2022',14,5);
insert into race_dispute values ('03-JUL-2022',4,6);
insert into race_dispute values ('03-JUL-2022',1,7);
insert into race_dispute values ('03-JUL-2022',47,8);
insert into race_dispute values ('03-JUL-2022',5,9);
insert into race_dispute values ('03-JUL-2022',20,10);
insert into race_dispute values ('03-JUL-2022',18,11);
insert into race_dispute values ('03-JUL-2022',6,12);
insert into race_dispute values ('03-JUL-2022',3,13);
insert into race_dispute values ('03-JUL-2022',22,14);
insert into race_dispute values ('03-JUL-2022',31,15);
insert into race_dispute values ('03-JUL-2022',10,16);
insert into race_dispute values ('03-JUL-2022',77,17);
insert into race_dispute values ('03-JUL-2022',63,18);
insert into race_dispute values ('03-JUL-2022',24,19);
insert into race_dispute values ('03-JUL-2022',23,20);

insert into race_dispute values ('09-JUL-2022',1,1);
insert into race_dispute values ('09-JUL-2022',16,2);
insert into race_dispute values ('09-JUL-2022',55,3);
insert into race_dispute values ('09-JUL-2022',63,4);
insert into race_dispute values ('09-JUL-2022',11,5);
insert into race_dispute values ('09-JUL-2022',31,6);
insert into race_dispute values ('09-JUL-2022',20,7);
insert into race_dispute values ('09-JUL-2022',44,8);
insert into race_dispute values ('09-JUL-2022',47,9);
insert into race_dispute values ('09-JUL-2022',77,10);
insert into race_dispute values ('09-JUL-2022',4,11);
insert into race_dispute values ('09-JUL-2022',3,12);
insert into race_dispute values ('09-JUL-2022',18,13);
insert into race_dispute values ('09-JUL-2022',24,14);
insert into race_dispute values ('09-JUL-2022',10,15);
insert into race_dispute values ('09-JUL-2022',23,16);
insert into race_dispute values ('09-JUL-2022',22,17);
insert into race_dispute values ('09-JUL-2022',6,18);
insert into race_dispute values ('09-JUL-2022',5,19);
insert into race_dispute values ('09-JUL-2022',14,20);

insert into race_dispute values ('10-JUL-2022',16,1);
insert into race_dispute values ('10-JUL-2022',1,2);
insert into race_dispute values ('10-JUL-2022',44,3);
insert into race_dispute values ('10-JUL-2022',63,4);
insert into race_dispute values ('10-JUL-2022',31,5);
insert into race_dispute values ('10-JUL-2022',47,6);
insert into race_dispute values ('10-JUL-2022',4,7);
insert into race_dispute values ('10-JUL-2022',20,8);
insert into race_dispute values ('10-JUL-2022',3,9);
insert into race_dispute values ('10-JUL-2022',14,10);
insert into race_dispute values ('10-JUL-2022',77,11);
insert into race_dispute values ('10-JUL-2022',23,12);
insert into race_dispute values ('10-JUL-2022',18,13);
insert into race_dispute values ('10-JUL-2022',24,14);
insert into race_dispute values ('10-JUL-2022',10,15);
insert into race_dispute values ('10-JUL-2022',22,16);
insert into race_dispute values ('10-JUL-2022',5,17);
insert into race_dispute values ('10-JUL-2022',55,18);
insert into race_dispute values ('10-JUL-2022',6,19);
insert into race_dispute values ('10-JUL-2022',11,20);

insert into race_dispute values ('24-JUL-2022',1,1);
insert into race_dispute values ('24-JUL-2022',44,2);
insert into race_dispute values ('24-JUL-2022',63,3);
insert into race_dispute values ('24-JUL-2022',11,4);
insert into race_dispute values ('24-JUL-2022',55,5);
insert into race_dispute values ('24-JUL-2022',14,6);
insert into race_dispute values ('24-JUL-2022',4,7);
insert into race_dispute values ('24-JUL-2022',31,8);
insert into race_dispute values ('24-JUL-2022',3,9);
insert into race_dispute values ('24-JUL-2022',18,10);
insert into race_dispute values ('24-JUL-2022',5,11);
insert into race_dispute values ('24-JUL-2022',10,12);
insert into race_dispute values ('24-JUL-2022',23,13);
insert into race_dispute values ('24-JUL-2022',77,14);
insert into race_dispute values ('24-JUL-2022',47,15);
insert into race_dispute values ('24-JUL-2022',24,16);
insert into race_dispute values ('24-JUL-2022',6,17);
insert into race_dispute values ('24-JUL-2022',20,18);
insert into race_dispute values ('24-JUL-2022',16,19);
insert into race_dispute values ('24-JUL-2022',22,20);

insert into race_dispute values ('31-JUL-2022',1,1);
insert into race_dispute values ('31-JUL-2022',44,2);
insert into race_dispute values ('31-JUL-2022',63,3);
insert into race_dispute values ('31-JUL-2022',55,4);
insert into race_dispute values ('31-JUL-2022',11,5);
insert into race_dispute values ('31-JUL-2022',16,6);
insert into race_dispute values ('31-JUL-2022',4,7);
insert into race_dispute values ('31-JUL-2022',14,8);
insert into race_dispute values ('31-JUL-2022',31,9);
insert into race_dispute values ('31-JUL-2022',5,10);
insert into race_dispute values ('31-JUL-2022',18,11);
insert into race_dispute values ('31-JUL-2022',10,12);
insert into race_dispute values ('31-JUL-2022',24,13);
insert into race_dispute values ('31-JUL-2022',47,14);
insert into race_dispute values ('31-JUL-2022',3,15);
insert into race_dispute values ('31-JUL-2022',20,16);
insert into race_dispute values ('31-JUL-2022',23,17);
insert into race_dispute values ('31-JUL-2022',6,18);
insert into race_dispute values ('31-JUL-2022',22,19);
insert into race_dispute values ('31-JUL-2022',77,20);

insert into race_dispute values ('28-AUG-2022',1,1);
insert into race_dispute values ('28-AUG-2022',11,2);
insert into race_dispute values ('28-AUG-2022',55,3);
insert into race_dispute values ('28-AUG-2022',63,4);
insert into race_dispute values ('28-AUG-2022',14,5);
insert into race_dispute values ('28-AUG-2022',16,6);
insert into race_dispute values ('28-AUG-2022',31,7);
insert into race_dispute values ('28-AUG-2022',5,8);
insert into race_dispute values ('28-AUG-2022',10,9);
insert into race_dispute values ('28-AUG-2022',23,10);
insert into race_dispute values ('28-AUG-2022',18,11);
insert into race_dispute values ('28-AUG-2022',4,12);
insert into race_dispute values ('28-AUG-2022',22,13);
insert into race_dispute values ('28-AUG-2022',24,14);
insert into race_dispute values ('28-AUG-2022',3,15);
insert into race_dispute values ('28-AUG-2022',20,16);
insert into race_dispute values ('28-AUG-2022',47,17);
insert into race_dispute values ('28-AUG-2022',6,18);
insert into race_dispute values ('28-AUG-2022',77,19);
insert into race_dispute values ('28-AUG-2022',44,20);

insert into race_dispute values ('04-SEP-2022',1,1);
insert into race_dispute values ('04-SEP-2022',63,2);
insert into race_dispute values ('04-SEP-2022',16,3);
insert into race_dispute values ('04-SEP-2022',44,4);
insert into race_dispute values ('04-SEP-2022',11,5);
insert into race_dispute values ('04-SEP-2022',14,6);
insert into race_dispute values ('04-SEP-2022',4,7);
insert into race_dispute values ('04-SEP-2022',55,8);
insert into race_dispute values ('04-SEP-2022',31,9);
insert into race_dispute values ('04-SEP-2022',18,10);
insert into race_dispute values ('04-SEP-2022',10,11);
insert into race_dispute values ('04-SEP-2022',23,12);
insert into race_dispute values ('04-SEP-2022',47,13);
insert into race_dispute values ('04-SEP-2022',5,14);
insert into race_dispute values ('04-SEP-2022',20,15);
insert into race_dispute values ('04-SEP-2022',24,16);
insert into race_dispute values ('04-SEP-2022',3,17);
insert into race_dispute values ('04-SEP-2022',6,18);
insert into race_dispute values ('04-SEP-2022',77,19);
insert into race_dispute values ('04-SEP-2022',22,20);

insert into race_dispute values ('11-SEP-2022',1,1);
insert into race_dispute values ('11-SEP-2022',16,2);
insert into race_dispute values ('11-SEP-2022',63,3);
insert into race_dispute values ('11-SEP-2022',55,4);
insert into race_dispute values ('11-SEP-2022',44,5);
insert into race_dispute values ('11-SEP-2022',11,6);
insert into race_dispute values ('11-SEP-2022',4,7);
insert into race_dispute values ('11-SEP-2022',10,8);
insert into race_dispute values ('11-SEP-2022',45,9);
insert into race_dispute values ('11-SEP-2022',24,10);
insert into race_dispute values ('11-SEP-2022',31,11);
insert into race_dispute values ('11-SEP-2022',47,12);
insert into race_dispute values ('11-SEP-2022',77,13);
insert into race_dispute values ('11-SEP-2022',22,14);
insert into race_dispute values ('11-SEP-2022',6,15);
insert into race_dispute values ('11-SEP-2022',20,16);
insert into race_dispute values ('11-SEP-2022',3,17);
insert into race_dispute values ('11-SEP-2022',18,18);
insert into race_dispute values ('11-SEP-2022',14,19);
insert into race_dispute values ('11-SEP-2022',5,20);

insert into race_dispute values ('02-OCT-2022',11,1);
insert into race_dispute values ('02-OCT-2022',16,2);
insert into race_dispute values ('02-OCT-2022',55,3);
insert into race_dispute values ('02-OCT-2022',4,4);
insert into race_dispute values ('02-OCT-2022',3,5);
insert into race_dispute values ('02-OCT-2022',18,6);
insert into race_dispute values ('02-OCT-2022',1,7);
insert into race_dispute values ('02-OCT-2022',5,8);
insert into race_dispute values ('02-OCT-2022',44,9);
insert into race_dispute values ('02-OCT-2022',10,10);
insert into race_dispute values ('02-OCT-2022',77,11);
insert into race_dispute values ('02-OCT-2022',20,12);
insert into race_dispute values ('02-OCT-2022',47,13);
insert into race_dispute values ('02-OCT-2022',63,14);
insert into race_dispute values ('02-OCT-2022',22,15);
insert into race_dispute values ('02-OCT-2022',31,16);
insert into race_dispute values ('02-OCT-2022',23,17);
insert into race_dispute values ('02-OCT-2022',14,18);
insert into race_dispute values ('02-OCT-2022',6,19);
insert into race_dispute values ('02-OCT-2022',24,20);

insert into race_dispute values ('09-OCT-2022',1,1);
insert into race_dispute values ('09-OCT-2022',11,2);
insert into race_dispute values ('09-OCT-2022',16,3);
insert into race_dispute values ('09-OCT-2022',31,4);
insert into race_dispute values ('09-OCT-2022',44,5);
insert into race_dispute values ('09-OCT-2022',5,6);
insert into race_dispute values ('09-OCT-2022',14,7);
insert into race_dispute values ('09-OCT-2022',63,8);
insert into race_dispute values ('09-OCT-2022',6,9);
insert into race_dispute values ('09-OCT-2022',4,10);
insert into race_dispute values ('09-OCT-2022',3,11);
insert into race_dispute values ('09-OCT-2022',18,12);
insert into race_dispute values ('09-OCT-2022',22,13);
insert into race_dispute values ('09-OCT-2022',20,14);
insert into race_dispute values ('09-OCT-2022',77,15);
insert into race_dispute values ('09-OCT-2022',24,16);
insert into race_dispute values ('09-OCT-2022',47,17);
insert into race_dispute values ('09-OCT-2022',10,18);
insert into race_dispute values ('09-OCT-2022',55,19);
insert into race_dispute values ('09-OCT-2022',23,20);

insert into race_dispute values ('23-OCT-2022',1,1);
insert into race_dispute values ('23-OCT-2022',44,2);
insert into race_dispute values ('23-OCT-2022',16,3);
insert into race_dispute values ('23-OCT-2022',11,4);
insert into race_dispute values ('23-OCT-2022',63,5);
insert into race_dispute values ('23-OCT-2022',4,6);
insert into race_dispute values ('23-OCT-2022',14,7);
insert into race_dispute values ('23-OCT-2022',5,8);
insert into race_dispute values ('23-OCT-2022',20,9);
insert into race_dispute values ('23-OCT-2022',22,10);
insert into race_dispute values ('23-OCT-2022',31,11);
insert into race_dispute values ('23-OCT-2022',24,12);
insert into race_dispute values ('23-OCT-2022',23,13);
insert into race_dispute values ('23-OCT-2022',10,14);
insert into race_dispute values ('23-OCT-2022',47,15);
insert into race_dispute values ('23-OCT-2022',3,16);
insert into race_dispute values ('23-OCT-2022',6,17);
insert into race_dispute values ('23-OCT-2022',18,18);
insert into race_dispute values ('23-OCT-2022',77,19);
insert into race_dispute values ('23-OCT-2022',55,20);

insert into race_dispute values ('30-OCT-2022',1,1);
insert into race_dispute values ('30-OCT-2022',44,2);
insert into race_dispute values ('30-OCT-2022',11,3);
insert into race_dispute values ('30-OCT-2022',63,4);
insert into race_dispute values ('30-OCT-2022',55,5);
insert into race_dispute values ('30-OCT-2022',16,6);
insert into race_dispute values ('30-OCT-2022',3,7);
insert into race_dispute values ('30-OCT-2022',31,8);
insert into race_dispute values ('30-OCT-2022',4,9);
insert into race_dispute values ('30-OCT-2022',77,10);
insert into race_dispute values ('30-OCT-2022',10,11);
insert into race_dispute values ('30-OCT-2022',23,12);
insert into race_dispute values ('30-OCT-2022',24,13);
insert into race_dispute values ('30-OCT-2022',5,14);
insert into race_dispute values ('30-OCT-2022',18,15);
insert into race_dispute values ('30-OCT-2022',47,16);
insert into race_dispute values ('30-OCT-2022',20,17);
insert into race_dispute values ('30-OCT-2022',6,18);
insert into race_dispute values ('30-OCT-2022',14,19);
insert into race_dispute values ('30-OCT-2022',22,20);

insert into race_dispute values ('12-NOV-2022',63,1);
insert into race_dispute values ('12-NOV-2022',55,2);
insert into race_dispute values ('12-NOV-2022',44,3);
insert into race_dispute values ('12-NOV-2022',1,4);
insert into race_dispute values ('12-NOV-2022',11,5);
insert into race_dispute values ('12-NOV-2022',16,6);
insert into race_dispute values ('12-NOV-2022',4,7);
insert into race_dispute values ('12-NOV-2022',20,8);
insert into race_dispute values ('12-NOV-2022',5,9);
insert into race_dispute values ('12-NOV-2022',10,10);
insert into race_dispute values ('12-NOV-2022',3,11);
insert into race_dispute values ('12-NOV-2022',47,12);
insert into race_dispute values ('12-NOV-2022',24,13);
insert into race_dispute values ('12-NOV-2022',77,14);
insert into race_dispute values ('12-NOV-2022',22,15);
insert into race_dispute values ('12-NOV-2022',18,16);
insert into race_dispute values ('12-NOV-2022',31,17);
insert into race_dispute values ('12-NOV-2022',14,18);
insert into race_dispute values ('12-NOV-2022',6,19);
insert into race_dispute values ('12-NOV-2022',23,20);

insert into race_dispute values ('13-NOV-2022',63,1);
insert into race_dispute values ('13-NOV-2022',44,2);
insert into race_dispute values ('13-NOV-2022',55,3);
insert into race_dispute values ('13-NOV-2022',16,4);
insert into race_dispute values ('13-NOV-2022',14,5);
insert into race_dispute values ('13-NOV-2022',1,6);
insert into race_dispute values ('13-NOV-2022',11,7);
insert into race_dispute values ('13-NOV-2022',31,8);
insert into race_dispute values ('13-NOV-2022',77,9);
insert into race_dispute values ('13-NOV-2022',18,10);
insert into race_dispute values ('13-NOV-2022',5,11);
insert into race_dispute values ('13-NOV-2022',24,12);
insert into race_dispute values ('13-NOV-2022',47,13);
insert into race_dispute values ('13-NOV-2022',10,14);
insert into race_dispute values ('13-NOV-2022',23,15);
insert into race_dispute values ('13-NOV-2022',6,16);
insert into race_dispute values ('13-NOV-2022',22,17);
insert into race_dispute values ('13-NOV-2022',4,18);
insert into race_dispute values ('13-NOV-2022',20,19);
insert into race_dispute values ('13-NOV-2022',3,20);

insert into race_dispute values ('20-NOV-2022',1,1);
insert into race_dispute values ('20-NOV-2022',16,2);
insert into race_dispute values ('20-NOV-2022',11,3);
insert into race_dispute values ('20-NOV-2022',55,4);
insert into race_dispute values ('20-NOV-2022',63,5);
insert into race_dispute values ('20-NOV-2022',4,6);
insert into race_dispute values ('20-NOV-2022',31,7);
insert into race_dispute values ('20-NOV-2022',18,8);
insert into race_dispute values ('20-NOV-2022',3,9);
insert into race_dispute values ('20-NOV-2022',5,10);
insert into race_dispute values ('20-NOV-2022',22,11);
insert into race_dispute values ('20-NOV-2022',24,12);
insert into race_dispute values ('20-NOV-2022',23,13);
insert into race_dispute values ('20-NOV-2022',10,14);
insert into race_dispute values ('20-NOV-2022',77,15);
insert into race_dispute values ('20-NOV-2022',47,16);
insert into race_dispute values ('20-NOV-2022',20,17);
insert into race_dispute values ('20-NOV-2022',44,18);
insert into race_dispute values ('20-NOV-2022',6,19);
insert into race_dispute values ('20-NOV-2022',14,20);

-- retire (in ordine dal primo ritirato di ogni race)
insert into retire values ('20-MAR-2022',10,'44','Guasto');
insert into retire values ('20-MAR-2022',1,'54','Guasto');
insert into retire values ('20-MAR-2022',11,'56','Incidente');
insert into retire values ('27-MAR-2022',47,'0','Incidente');
insert into retire values ('27-MAR-2022',22,'0','Guasto');
insert into retire values ('27-MAR-2022',6,'14','Incidente');
insert into retire values ('27-MAR-2022',3,'35','Guasto');
insert into retire values ('27-MAR-2022',14,'35','Guasto');
insert into retire values ('27-MAR-2022',77,'36','Guasto');
insert into retire values ('27-MAR-2022',23,'47','Incidente');
insert into retire values ('10-APR-2022',55,'1','Incidente');
insert into retire values ('10-APR-2022',5,'22','Incidente');
insert into retire values ('10-APR-2022',1,'38','Guasto');
insert into retire values ('23-APR-2022',24,'0','Incidente');
insert into retire values ('24-APR-2022',55,'0','Incidente');
insert into retire values ('24-APR-2022',14,'6','Incidente');
insert into retire values ('08-MAY-2022',24,'6','Guasto');
insert into retire values ('08-MAY-2022',4,'39','Incidente');
insert into retire values ('08-MAY-2022',10,'45','Guasto');
insert into retire values ('08-MAY-2022',5,'54','Incidente');
insert into retire values ('08-MAY-2022',20,'56','Incidente');
insert into retire values ('22-MAY-2022',16,'27','Guasto');
insert into retire values ('22-MAY-2022',24,'28','Guasto');
insert into retire values ('29-MAY-2022',20,'19','Guasto');
insert into retire values ('29-MAY-2022',47,'24','Incidente');
insert into retire values ('29-MAY-2022',23,'48','Guasto');
insert into retire values ('12-JUN-2022',55,'8','Guasto');
insert into retire values ('12-JUN-2022',16,'21','Guasto');
insert into retire values ('12-JUN-2022',24,'23','Guasto');
insert into retire values ('12-JUN-2022',20,'31','Guasto');
insert into retire values ('12-JUN-2022',18,'46','Guasto');
insert into retire values ('19-JUN-2022',11,'7','Guasto');
insert into retire values ('19-JUN-2022',47,'18','Guasto');
insert into retire values ('19-JUN-2022',22,'47','Incidente');
insert into retire values ('03-JUL-2022',23,'0','Incidente');
insert into retire values ('03-JUL-2022',24,'0','Incidente');
insert into retire values ('03-JUL-2022',63,'0','Incidente');
insert into retire values ('03-JUL-2022',77,'20','Guasto');
insert into retire values ('03-JUL-2022',10,'26','Guasto');
insert into retire values ('03-JUL-2022',31,'37','Guasto');
insert into retire values ('09-JUL-2022',14,'0','Guasto');
insert into retire values ('09-JUL-2022',5,'21','Incidente');
insert into retire values ('10-JUL-2022',11,'24','Incidente');
insert into retire values ('10-JUL-2022',6,'48','Guasto');
insert into retire values ('10-JUL-2022',55,'56','Guasto');
insert into retire values ('24-JUL-2022',22,'17','Guasto');
insert into retire values ('24-JUL-2022',16,'17','Incidente');
insert into retire values ('24-JUL-2022',20,'37','Incidente');
insert into retire values ('24-JUL-2022',6,'40','Incidente');
insert into retire values ('24-JUL-2022',24,'47','Guasto');
insert into retire values ('31-JUL-2022',77,'65','Guasto');
insert into retire values ('28-AUG-2022',44,'0','Incidente');
insert into retire values ('28-AUG-2022',77,'1','Incidente');
insert into retire values ('04-SEP-2022',22,'43','Guasto');
insert into retire values ('04-SEP-2022',77,'53','Guasto');
insert into retire values ('11-SEP-2022',5,'10','Guasto');
insert into retire values ('11-SEP-2022',14,'31','Guasto');
insert into retire values ('11-SEP-2022',18,'39','Guasto');
insert into retire values ('11-SEP-2022',3,'45','Guasto');
insert into retire values ('02-OCT-2022',24,'6','Incidente');
insert into retire values ('02-OCT-2022',6,'7','Incidente');
insert into retire values ('02-OCT-2022',14,'20','Guasto');
insert into retire values ('02-OCT-2022',23,'25','Incidente');
insert into retire values ('02-OCT-2022',31,'26','Guasto');
insert into retire values ('02-OCT-2022',22,'34','Incidente');
insert into retire values ('09-OCT-2022',23,'0','Guasto');
insert into retire values ('09-OCT-2022',55,'0','Incidente');
insert into retire values ('23-OCT-2022',55,'1','Incidente');
insert into retire values ('23-OCT-2022',77,'16','Incidente');
insert into retire values ('23-OCT-2022',18,'21','Incidente');
insert into retire values ('30-OCT-2022',22,'50','Incidente');
insert into retire values ('30-OCT-2022',14,'62','Guasto');
insert into retire values ('12-NOV-2022',23,'12','Guasto');
insert into retire values ('13-NOV-2022',3,'0','Incidente');
insert into retire values ('13-NOV-2022',20,'0','Incidente');
insert into retire values ('13-NOV-2022',4,'50','Guasto');
insert into retire values ('20-NOV-2022',14,'27','Guasto');
insert into retire values ('20-NOV-2022',6,'55','Guasto');
insert into retire values ('20-NOV-2022',44,'55','Guasto');