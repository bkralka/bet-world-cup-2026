--
-- PostgreSQL database dump
--

\restrict clu0m3TjNfKnaySEYL0Ryn0pU6dld8SQiZrnHdzKzj8Wz5pQyHT2Ep1iyi0gHac

-- Dumped from database version 18.4 (Debian 18.4-1.pgdg12+1)
-- Dumped by pg_dump version 18.4 (Ubuntu 18.4-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: bet_world_cup_2026_db_live_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO bet_world_cup_2026_db_live_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: matches; Type: TABLE; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE TABLE public.matches (
    id integer NOT NULL,
    home_team character varying,
    away_team character varying,
    match_date timestamp without time zone,
    result character varying,
    penalties character varying,
    is_locked boolean,
    is_finished boolean,
    stage character varying,
    multiplier integer,
    scorers json,
    scorer_teams json DEFAULT '[]'::json,
    scorer_minutes json DEFAULT '[]'::json
);


ALTER TABLE public.matches OWNER TO bet_world_cup_2026_db_live_user;

--
-- Name: matches_id_seq; Type: SEQUENCE; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE SEQUENCE public.matches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.matches_id_seq OWNER TO bet_world_cup_2026_db_live_user;

--
-- Name: matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

ALTER SEQUENCE public.matches_id_seq OWNED BY public.matches.id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE TABLE public.players (
    id integer NOT NULL,
    username character varying,
    full_name character varying,
    email character varying,
    password character varying NOT NULL,
    is_active boolean,
    is_alive boolean,
    shields integer,
    total_points integer,
    correct_predictions integer,
    favorite_team character varying,
    star_player character varying,
    created_at timestamp without time zone,
    current_streak integer,
    longest_streak integer,
    comeback_points integer,
    revival_used boolean,
    favorite_locked boolean,
    favorite_team_points integer,
    star_player_points integer
);


ALTER TABLE public.players OWNER TO bet_world_cup_2026_db_live_user;

--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE SEQUENCE public.players_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.players_id_seq OWNER TO bet_world_cup_2026_db_live_user;

--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

ALTER SEQUENCE public.players_id_seq OWNED BY public.players.id;


--
-- Name: user_picks; Type: TABLE; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE TABLE public.user_picks (
    id integer NOT NULL,
    player_id integer,
    match_id integer,
    predicted_result character varying,
    points_earned integer,
    bonus_points integer,
    points_breakdown json,
    created_at timestamp without time zone
);


ALTER TABLE public.user_picks OWNER TO bet_world_cup_2026_db_live_user;

--
-- Name: user_picks_id_seq; Type: SEQUENCE; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE SEQUENCE public.user_picks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_picks_id_seq OWNER TO bet_world_cup_2026_db_live_user;

--
-- Name: user_picks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

ALTER SEQUENCE public.user_picks_id_seq OWNED BY public.user_picks.id;


--
-- Name: matches id; Type: DEFAULT; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

ALTER TABLE ONLY public.matches ALTER COLUMN id SET DEFAULT nextval('public.matches_id_seq'::regclass);


--
-- Name: players id; Type: DEFAULT; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

ALTER TABLE ONLY public.players ALTER COLUMN id SET DEFAULT nextval('public.players_id_seq'::regclass);


--
-- Name: user_picks id; Type: DEFAULT; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

ALTER TABLE ONLY public.user_picks ALTER COLUMN id SET DEFAULT nextval('public.user_picks_id_seq'::regclass);


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

COPY public.matches (id, home_team, away_team, match_date, result, penalties, is_locked, is_finished, stage, multiplier, scorers, scorer_teams, scorer_minutes) FROM stdin;
45	Portugalia	Uzbekistan	2026-06-23 19:00:00	\N	\N	f	f	group	1	[]	[]	[]
46	Anglia	Ghana	2026-06-23 22:00:00	\N	\N	f	f	group	1	[]	[]	[]
47	Panama	Chorwacja	2026-06-24 01:00:00	\N	\N	f	f	group	1	[]	[]	[]
48	Kolumbia	DR Konga	2026-06-24 04:00:00	\N	\N	f	f	group	1	[]	[]	[]
49	Szwajcaria	Kanada	2026-06-24 21:00:00	\N	\N	f	f	group	1	[]	[]	[]
50	Bośnia i Hercegowina	Katar	2026-06-24 21:00:00	\N	\N	f	f	group	1	[]	[]	[]
51	Maroko	Haiti	2026-06-25 00:00:00	\N	\N	f	f	group	1	[]	[]	[]
52	Szkocja	Brazylia	2026-06-25 00:00:00	\N	\N	f	f	group	1	[]	[]	[]
53	RPA	Korea Południowa	2026-06-25 03:00:00	\N	\N	f	f	group	1	[]	[]	[]
54	Czechy	Meksyk	2026-06-25 03:00:00	\N	\N	f	f	group	1	[]	[]	[]
55	Curacao	WKS	2026-06-25 22:00:00	\N	\N	f	f	group	1	[]	[]	[]
56	Ekwador	Niemcy	2026-06-25 22:00:00	\N	\N	f	f	group	1	[]	[]	[]
57	Japonia	Szwecja	2026-06-26 01:00:00	\N	\N	f	f	group	1	[]	[]	[]
58	Tunezja	Holandia	2026-06-26 01:00:00	\N	\N	f	f	group	1	[]	[]	[]
59	Paragwaj	Australia	2026-06-26 04:00:00	\N	\N	f	f	group	1	[]	[]	[]
60	Turcja	USA	2026-06-26 04:00:00	\N	\N	f	f	group	1	[]	[]	[]
61	Norwegia	Francja	2026-06-26 21:00:00	\N	\N	f	f	group	1	[]	[]	[]
62	Senegal	Irak	2026-06-26 21:00:00	\N	\N	f	f	group	1	[]	[]	[]
63	RZP	Arabia Saudyjska	2026-06-27 02:00:00	\N	\N	f	f	group	1	[]	[]	[]
64	Urugwaj	Hiszpania	2026-06-27 02:00:00	\N	\N	f	f	group	1	[]	[]	[]
65	Egipt	Iran	2026-06-27 05:00:00	\N	\N	f	f	group	1	[]	[]	[]
66	Nowa Zelandia	Belgia	2026-06-27 05:00:00	\N	\N	f	f	group	1	[]	[]	[]
67	Chorwacja	Ghana	2026-06-27 23:00:00	\N	\N	f	f	group	1	[]	[]	[]
68	Panama	Anglia	2026-06-27 23:00:00	\N	\N	f	f	group	1	[]	[]	[]
69	DR Konga	Uzbekistan	2026-06-28 01:30:00	\N	\N	f	f	group	1	[]	[]	[]
70	Kolumbia	Portugalia	2026-06-28 01:30:00	\N	\N	f	f	group	1	[]	[]	[]
71	Algieria	Austria	2026-06-28 04:00:00	\N	\N	f	f	group	1	[]	[]	[]
72	Jordania	Argentyna	2026-06-28 04:00:00	\N	\N	f	f	group	1	[]	[]	[]
6	Brazylia	Maroko	2026-06-14 00:00:00	1:1	\N	t	t	group	1	["Vinicius Junior", "Ismael Saibari"]	["Brazylia", "Maroko"]	["32", "21"]
7	Haiti	Szkocja	2026-06-14 03:00:00	0:1	\N	t	t	group	1	["John Mcginn"]	["Szkocja"]	["28"]
5	Katar	Szwajcaria	2026-06-13 21:00:00	1:1	\N	t	t	group	1	["Breel Embolo", "Samob\\u00f3j"]	["Katar", "Szwajcaria"]	["17", "90+4"]
3	Kanada	Bośnia i Hercegowina	2026-06-12 21:00:00	1:1	\N	t	t	group	1	["Cyle Larin", "Jovo Lukic"]	["Kanada", "Bo\\u015bnia i Hercegowina"]	["78", "21"]
10	Holandia	Japonia	2026-06-14 22:00:00	2:2	\N	t	t	group	1	["Virgil Van Dijk", "Crysencio Summerville", "Keito Nakamura", "Daichi Kamada"]	["Holandia", "Holandia", "Japonia", "Japonia"]	["51", "64", "57", "89"]
11	WKS	Ekwador	2026-06-15 01:00:00	1:0	\N	t	t	group	1	["Amad Diallo"]	["WKS"]	["90"]
16	Iran	Nowa Zelandia	2026-06-16 03:00:00	2:2	\N	t	t	group	1	["Ramin Rezaeian", "Mohammad Mohebi", "Elijah Henry Just", "Elijah Henry Just"]	["Iran", "Iran", "Nowa Zelandia", "Nowa Zelandia"]	["32", "64", "7", "54"]
13	Hiszpania	RZP	2026-06-15 18:00:00	0:0	\N	t	t	group	1	[]	[]	[]
21	Portugalia	DR Konga	2026-06-17 19:00:00	1:1	\N	t	t	group	1	["Joao Neves", "Yoane Wissa"]	["Portugalia", "DR Konga"]	["6", "45+5"]
32	Turcja	Paragwaj	2026-06-20 06:00:00	0:1	\N	t	t	group	1	["Matias Galarza"]	["Paragwaj"]	["2"]
14	Belgia	Egipt	2026-06-15 21:00:00	1:1	\N	t	t	group	1	["Samob\\u00f3j", "Emam Ashour"]	["Belgia", "Egipt"]	["66", "20"]
12	Szwecja	Tunezja	2026-06-15 04:00:00	5:1	\N	t	t	group	1	["Yasin Ayari", "Alexander Isak", "Viktor Gyokeres", "Mattias Svanberg", "Yasin Ayari", "Omar Rekik"]	["Szwecja", "Szwecja", "Szwecja", "Szwecja", "Szwecja", "Tunezja"]	["7", "30", "59", "84", "90+6", "43"]
30	Szkocja	Maroko	2026-06-20 00:00:00	0:1	\N	t	t	group	1	["Ismael Saibari"]	["Maroko"]	["2"]
15	Arabia Saudyjska	Urugwaj	2026-06-16 00:00:00	1:1	\N	t	t	group	1	["Abdulelah Al Amri", "Maximiliano Araujo"]	["Arabia Saudyjska", "Urugwaj"]	["41", "80"]
43	Norwegia	Senegal	2026-06-23 02:00:00	3:2	\N	t	t	group	1	["Marcus Pedersen", "Erling Haaland", "Erling Haaland", "Ismaila Sarr", "Ismaila Sarr"]	["Norwegia", "Norwegia", "Norwegia", "Senegal", "Senegal"]	["43", "48", "58", "53", "90+3"]
19	Argentyna	Algieria	2026-06-17 03:00:00	3:0	\N	t	t	group	1	["Lionel Messi", "Lionel Messi", "Lionel Messi"]	["Argentyna", "Argentyna", "Argentyna"]	["17", "60", "76"]
23	Ghana	Panama	2026-06-18 01:00:00	1:0	\N	t	t	group	1	["Caleb Yirenkyi"]	["Ghana"]	["90+5"]
25	Czechy	RPA	2026-06-18 18:00:00	1:1	\N	t	t	group	1	["Michal Sadilek", "Teboho Mokoena"]	["Czechy", "RPA"]	["6", "83"]
28	Meksyk	Korea Południowa	2026-06-19 03:00:00	1:0	\N	t	t	group	1	["Luis Romo"]	["Meksyk"]	["50"]
31	Brazylia	Haiti	2026-06-20 03:00:00	3:0	\N	t	t	group	1	["Matheus Cunha", "Matheus Cunha", "Vinicius Junior"]	["Brazylia", "Brazylia", "Brazylia"]	["23", "36", "45+3"]
33	Holandia	Szwecja	2026-06-20 19:00:00	5:1	\N	t	t	group	1	["Brian Brobbey", "Brian Brobbey", "Cody Gakpo", "Cody Gakpo", "Crysencio Summerville", "Anthony Elanga"]	["Holandia", "Holandia", "Holandia", "Holandia", "Holandia", "Szwecja"]	["5", "17", "47", "54", "89", "59"]
34	Niemcy	WKS	2026-06-20 22:00:00	2:1	\N	t	t	group	1	["Deniz Undav", "Deniz Undav", "Franck Kessie"]	["Niemcy", "Niemcy", "WKS"]	["68", "90+4", "30"]
36	Tunezja	Japonia	2026-06-21 06:00:00	0:4	\N	t	t	group	1	["Daichi Kamada", "Ayase Ueda", "Junya Ito", "Ayase Ueda"]	["Japonia", "Japonia", "Japonia", "Japonia"]	["4", "31", "69", "83"]
39	Urugwaj	RZP	2026-06-22 00:00:00	2:2	\N	t	t	group	1	["Maximiliano Araujo", "Agustin Canobbio", "Kevin Lenini", "Helio Varela"]	["Urugwaj", "Urugwaj", "RZP", "RZP"]	["44", "45+6", "21", "61"]
24	Uzbekistan	Kolumbia	2026-06-18 04:00:00	1:3	\N	t	t	group	1	["Abbosbek Fayzullaev", "Daniel Munoz", "Luis Diaz", "Jaminton Campaz"]	["Uzbekistan", "Kolumbia", "Kolumbia", "Kolumbia"]	["60", "40", "65", "90+9"]
29	USA	Australia	2026-06-19 21:00:00	2:0	\N	t	t	group	1	["Samob\\u00f3j", "Alex Freeman"]	["USA", "USA"]	["11", "43"]
41	Argentyna	Austria	2026-06-22 19:00:00	2:0	\N	t	t	group	1	["Lionel Messi", "Lionel Messi"]	["Argentyna", "Argentyna"]	["38", "90+5"]
18	Irak	Norwegia	2026-06-17 00:00:00	1:4	\N	t	t	group	1	["Aymen Hussein", "Erling Haaland", "Erling Haaland", "Leo Ostigard", "Samob\\u00f3j"]	["Irak", "Norwegia", "Norwegia", "Norwegia", "Norwegia"]	["39", "29", "43", "76", "90+6"]
44	Jordania	Algieria	2026-06-23 05:00:00	1:2	\N	t	t	group	1	["Nizar Al Rashdan", "Nadir Benbouali", "Amine Gouiri"]	["Jordania", "Algieria", "Algieria"]	["36", "69", "82"]
38	Belgia	Iran	2026-06-21 21:00:00	0:0	\N	t	t	group	1	[]	[]	[]
35	Ekwador	Curacao	2026-06-21 02:00:00	0:0	\N	t	t	group	1	[]	[]	[]
1	Meksyk	RPA	2026-06-11 21:00:00	2:0	\N	t	t	group	1	["Julian Quinones", "Raul Jimenez"]	["Meksyk", "Meksyk"]	["9", "67"]
2	Korea Południowa	Czechy	2026-06-12 04:00:00	2:1	\N	t	t	group	1	["Hwang In-Beom", "Oh Hyeon-Gyu", "Ladislav Krejci"]	["Korea Po\\u0142udniowa", "Korea Po\\u0142udniowa", "Czechy"]	["67", "80", "59"]
4	USA	Paragwaj	2026-06-13 03:00:00	4:1	\N	t	t	group	1	["Samob\\u00f3j", "Folarin Balogun", "Folarin Balogun", "Giovanni Reyna", "Mauricio"]	["USA", "USA", "USA", "USA", "Paragwaj"]	["7", "31", "45+5", "90+8", "73"]
8	Australia	Turcja	2026-06-14 06:00:00	2:0	\N	t	t	group	1	["Nestory Irankunda", "Connor Metcalfe"]	["Australia", "Australia"]	["27", "75"]
9	Niemcy	Curacao	2026-06-14 19:00:00	7:1	\N	t	t	group	1	["Felix Nmecha", "Nico Schlotterbeck", "Kai Havertz", "Jamal Musiala", "Nathaniel Brown", "Deniz Undav", "Kai Havertz", "Livano Comenencia"]	["Niemcy", "Niemcy", "Niemcy", "Niemcy", "Niemcy", "Niemcy", "Niemcy", "Curacao"]	["6", "38", "45+5", "47", "68", "78", "88", "21"]
17	Francja	Senegal	2026-06-16 21:00:00	3:1	\N	t	t	group	1	["Kylian Mbappe", "Bradley Barcola", "Kylian Mbappe", "Ibrahim Mbaye"]	["Francja", "Francja", "Francja", "Senegal"]	["66", "82", "90+6", "90+5"]
20	Austria	Jordania	2026-06-17 06:00:00	3:1	\N	t	t	group	1	["Romano Schmid", "Samob\\u00f3j", "Marko Arnautovic", "Ali Olwan"]	["Austria", "Austria", "Austria", "Jordania"]	["21", "76", "90+12", "50"]
22	Anglia	Chorwacja	2026-06-17 22:00:00	4:2	\N	t	t	group	1	["Harry Kane", "Harry Kane", "Jude Bellingham", "Marcus Rashford", "Martin Baturina", "Petar Musa"]	["Anglia", "Anglia", "Anglia", "Anglia", "Chorwacja", "Chorwacja"]	["12", "42", "47", "85", "36", "45+5"]
26	Szwajcaria	Bośnia i Hercegowina	2026-06-18 21:00:00	4:1	\N	t	t	group	1	["Johan Manzambi", "Ruben Vargas", "Johan Manzambi", "Granit Xhaka", "Ermin Mahmic"]	["Szwajcaria", "Szwajcaria", "Szwajcaria", "Szwajcaria", "Bo\\u015bnia i Hercegowina"]	["74", "84", "90", "90+7", "90+3"]
27	Kanada	Katar	2026-06-19 00:00:00	6:0	\N	t	t	group	1	["Cyle Larin", "Jonathan David", "Jonathan David", "Nathan Saliba", "Samob\\u00f3j", "Jonathan David"]	["Kanada", "Kanada", "Kanada", "Kanada", "Kanada", "Kanada"]	["16", "29", "45+3", "64", "75", "90+2"]
37	Hiszpania	Arabia Saudyjska	2026-06-21 18:00:00	4:0	\N	t	t	group	1	["Lamine Yamal", "Mikel Oyarzabal", "Mikel Oyarzabal", "Samob\\u00f3j"]	["Hiszpania", "Hiszpania", "Hiszpania", "Hiszpania"]	["10", "21", "24", "49"]
40	Nowa Zelandia	Egipt	2026-06-22 03:00:00	1:3	\N	t	t	group	1	["Finn Surman", "Mostafa Ziko", "Mohamed Salah", "Trezeguet"]	["Nowa Zelandia", "Egipt", "Egipt", "Egipt"]	["15", "58", "67", "82"]
42	Francja	Irak	2026-06-22 23:00:00	3:0	\N	t	t	group	1	["Kylian Mbappe", "Kylian Mbappe", "Ousmane Dembele"]	["Francja", "Francja", "Francja"]	["14", "54", "66"]
\.


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

COPY public.players (id, username, full_name, email, password, is_active, is_alive, shields, total_points, correct_predictions, favorite_team, star_player, created_at, current_streak, longest_streak, comeback_points, revival_used, favorite_locked, favorite_team_points, star_player_points) FROM stdin;
1	krala	Bartosz	krala@onepick.pl	$2b$12$.a4DNbwMdITwn1K.Aij3vOVO.lCEJsAi1tyIxYkbFNS5hngNRMr5u	t	t	2	39	26	Portugalia	Cristiano Ronaldo	2026-06-10 16:41:26.852824	5	5	0	f	t	0	0
2	Makuwka	Kacper	Makuwka@onepick.pl	$2b$12$GAvzNtIKBI0fx6aNQrr6S.7qKKJtCk/kBZMvscV2y8j7I8akC48Pq	t	t	2	47	25	Francja	Kylian Mbappe	2026-06-10 16:47:37.449635	5	5	0	f	t	2	4
3	rogal99	Daniel	rogal99@onepick.pl	$2b$12$24P3OBFy8WA5sbp0Xc8Xdu.jABvk.O1Ma72eYmOzVmD5z7YeSa6se	t	t	2	45	28	Portugalia	Cristiano Ronaldo	2026-06-10 16:56:59.247783	1	4	0	f	t	0	0
4	tomoszef997	Tomek	tomoszef997@onepick.pl	$2b$12$HKPLv2OEzeGgUFsiUfz.2OGP79R25ga2UFV/Ph4SSz0c4iryoxovu	t	t	2	38	24	Hiszpania	Lamine Yamal	2026-06-10 16:59:48.159605	1	6	0	f	t	0	0
8	Szumi	Aleksander	Szumi@onepick.pl	$2b$12$w9EgnaXI/M84DMVT1J.suO41dMZ2nkOyQi/NlZjp42lSpg8GAMqyO	t	t	2	48	27	Francja	Kylian Mbappe	2026-06-10 17:01:10.446501	5	5	0	f	t	2	4
9	piotrek8412	Piotrek	piotrek8412@onepick.pl	$2b$12$KfW.8T8Lhtgely.ZBZuC7enMHe4AXR9V4dViQBQ4jQP70WlMYAdP.	t	t	2	23	19	Hiszpania	Lautaro Martinez	2026-06-10 17:03:18.251893	0	4	0	f	t	1	0
10	matt	Mateusz	matt@onepick.pl	$2b$12$C2pbvxqE0PHBhqfaBLT8iO2vErrvAaII7OhWgfwMgvtfxZLunQzoW	t	t	2	38	24	Francja	Kylian Mbappe	2026-06-10 17:08:42.150127	4	4	0	f	t	2	4
19	Tomcio	Jakub	Tomcio@onepick.pl	$2b$12$KU88s7WN428I7akY0F7cxun2CKUPD/eoP4lVTi1q0Wza2H9sk0136	t	t	2	52	26	Francja	Kylian Mbappe	2026-06-10 17:33:51.04786	0	7	0	f	t	2	4
18	Mirek	Milosz	Mirek@onepick.pl	$2b$12$JoUZEsQMGHOznpimRq7RneXMtPsMUz7onnLuT8JjIoljizyPFs3Ie	t	t	2	65	30	Hiszpania	Kylian Mbappe	2026-06-10 17:31:42.949509	1	10	0	f	t	1	4
21	Kryś	Krystian	Kryś@onepick.pl	$2b$12$DapO5Av.xQmv0RlIrH9dJODiagzZ6eZnIq86HiRZ2AGCRa53vom0S	t	t	2	38	22	Hiszpania	Kylian Mbappe	2026-06-10 17:44:26.45018	3	4	0	f	t	1	4
22	Igorek2016	Igor	Igorek2016@onepick.pl	$2b$12$H3Wrvoy9kFf8t5AHORK3yOxNqNCe/x5H9Iy1onaPI7iunlxcauOlW	t	t	2	25	21	Hiszpania	Michael Olise	2026-06-10 17:44:33.355847	0	5	0	f	t	1	0
23	Zalena	Kacper	Zalena@onepick.pl	$2b$12$nG8LDEMcGUCWxWRKNlvz5urSHynpHs0rCle2zSdyZhvFW/z19xxpa	t	t	2	48	26	Hiszpania	Kylian Mbappe	2026-06-10 17:46:12.346892	1	6	0	f	t	1	4
24	pola	pola	pola@onepick.pl	$2b$12$G4cUu9rCaRUrK9HpMLV6Ueh3VsTdA608fqIM6k2os7U4c4GzxwoO.	t	t	2	57	28	Hiszpania	Harry Kane	2026-06-10 18:09:55.25301	5	10	0	f	t	1	2
25	kuba4617	Kuba	kuba4617@onepick.pl	$2b$12$qWfDLHkwacCfxGPCy5pUwOL6r3JiGsTaJS4Z/S6VHP5KQq4g7//.G	t	t	2	48	28	Francja	Kylian Mbappe	2026-06-10 18:24:54.447192	1	6	0	f	t	2	4
27	Bossman	Michał	Bossman@onepick.pl	$2b$12$ECSc/n6bMBADQwrfMuzHxOyq7MMZ/y/JPjv0USV3gDLy0atLiBsye	t	t	2	36	26	Argentyna	Ousmane Dembele	2026-06-10 20:00:13.354962	5	5	0	f	t	2	1
29	Zagkub	Jakub	Zagkub@onepick.pl	$2b$12$aaMpR8gugZNRCQ9B7bDXEuYXvJn9TZhtKeW6x6LLtxIECHbZpmyDG	t	t	2	34	24	Hiszpania	Kylian Mbappe	2026-06-10 20:11:21.146091	1	4	0	f	t	1	4
11	Wosiu	Igor	Wosiu@onepick.pl	$2b$12$yUV1aoM1/RxlsDb0y6Znse8LGnbrV7Y9E.RCwSd0Ez5wxQimnbCcC	t	t	2	47	26	Meksyk	Harry Kane	2026-06-10 17:09:22.260296	0	6	0	f	t	2	2
12	Arturo	Artur	Arturo@onepick.pl	$2b$12$lHBKNMd5ANfzlczHpbxvzOw/Fqlm0D8YVw6HFMUTebyPjQn.yBl32	t	t	2	45	27	Hiszpania	Kylian Mbappe	2026-06-10 17:14:21.349394	5	6	0	f	t	1	4
14	tommy	tomasz	tommy@onepick.pl	$2b$12$S2NSwyjukqHZ6ojJcYKozOSL0aFHqobf7RTei96DYPCpjgTDFXmf6	t	t	2	44	26	Francja	Kylian Mbappe	2026-06-10 17:16:01.849347	1	4	0	f	t	2	4
16	młody szumi	Szymon	młody szumi@onepick.pl	$2b$12$UAOiXu2N840dkpEm6kdcAOo.5Ng6Z7RCNxaFeYwAeAKUuVC2/UVsG	t	t	2	49	26	Hiszpania	Kylian Mbappe	2026-06-10 17:24:19.150629	5	5	0	f	t	1	4
17	Mundeek	Klaudiusz	Mundeek@onepick.pl	$2b$12$cUB8MFwccLLaUdda3Vf.AeqwmsOEccOVl6sfs1jwF5Vea5zRC3b3.	t	t	2	28	19	Brazylia	Neymar	2026-06-10 17:31:07.254973	6	6	0	f	t	1	0
26	Cis	Jakub	Cis@onepick.pl	$2b$12$ZABltTWGyA3f1D4tn7GVsOabImD5x5pvAv9sX7S.XzZ6/GLeXUvgC	t	t	2	42	22	Hiszpania	Erling Haaland	2026-06-10 18:30:24.348072	1	6	0	f	t	1	2
28	deps	Patryk	deps@onepick.pl	$2b$12$3jHCrvNE0.bz7ctoq8t9EOTybHJlazhKSNR7PfWyGFVQcgEtargLO	t	t	2	42	23	Portugalia	Erling Haaland	2026-06-10 20:09:07.447212	4	5	0	f	t	0	2
33	mati_ufc	Mateusz	mati_ufc@onepick.pl	$2b$12$RISHLlo6.qhJuAzm60xZuOU2P7et3VNF1foiUnEwFbeqaZeDt.xGu	t	t	2	47	26	Francja	Kylian Mbappe	2026-06-10 21:19:04.651863	5	5	0	f	t	2	4
36	tobiking	Tobiasz	tobiking@onepick.pl	$2b$12$7KhJ61QtWwPR.6Oub2f5yetk2r1vdQySol3OiRjk7lOHFWK5ORfnu	t	t	2	40	26	Francja	Kylian Mbappe	2026-06-11 09:16:36.578686	1	6	0	f	t	2	4
37	fificzi	Filip	fificzi@onepick.pl	$2b$12$alkoNijznbr8nK01G3FWlepXcefhIqEmPc50Jbdo518kDFkaQCJM2	t	t	2	49	26	Francja	Harry Kane	2026-06-11 11:01:39.379274	1	6	0	f	t	2	2
39	arekfire	Arek	arekfire@onepick.pl	$2b$12$N7fq6K3I6OQlTTfCrzAC0.JdOxYtxJXrjdYi0LQu3stsVgpXWQtiW	t	t	2	51	26	Francja	Kylian Mbappe	2026-06-11 18:05:54.843428	5	6	0	f	t	2	4
30	majkel	Michał	majkel@onepick.pl	$2b$12$kAOiD37deXNU2IAv7/.qPOBdObSpr60V9LpENQ0cM2USmMnug5j0O	t	t	2	50	26	Francja	Erling Haaland	2026-06-10 20:39:08.351214	5	5	0	f	t	2	2
32	Butrym6	Kuba	Butrym6@onepick.pl	$2b$12$QQxgsdt4CAUWpu3jS1WpF.XAVgOe1hZ9k2oYSKC6nECPUdLXCS1Sq	t	t	2	37	25	Brazylia	Erling Haaland	2026-06-10 20:55:45.347976	0	5	0	f	t	0	2
31	kralcia	Paulina	kralcia@onepick.pl	$2b$12$zh1A08U6yULLDHJx7dm7MOOrJ/6RjQ3IAK03o3hdimG4GV1AoYjfS	t	t	2	32	23	Hiszpania	Harry Kane	2026-06-10 20:46:09.452872	0	4	0	f	t	1	2
35	wojciu	Wojtek	wojciu@onepick.pl	$2b$12$yVluB6WkLDpF.sDK3UZqlejaBf6YX.gSBfu4sdWJUuclOETwDO1EC	t	t	2	44	25	Argentyna	Desire Doue	2026-06-11 06:19:20.525527	0	6	0	f	t	2	0
38	k0meta	Mateusz	k0meta@onepick.pl	$2b$12$V3oIhztm6xrWHfW0ffNMcelWgI5lDL1jabhgCJDYJ.CChcILHt8aS	t	t	2	48	27	Francja	Kylian Mbappe	2026-06-11 17:46:49.549558	0	6	0	f	t	2	4
\.


--
-- Data for Name: user_picks; Type: TABLE DATA; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

COPY public.user_picks (id, player_id, match_id, predicted_result, points_earned, bonus_points, points_breakdown, created_at) FROM stdin;
1475	39	45	3:0	0	0	\N	2026-06-23 06:11:40.59098
11	2	8	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 16:49:01.644947
6	2	4	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 16:48:37.16513
289	11	9	6:0	3	0	{"base": 1, "high_score": 2, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-12 21:15:24.729707
12	1	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-10 16:49:28.153859
32	9	4	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:04:03.34124
43	10	4	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:09:36.206799
1477	39	47	0:3	0	0	\N	2026-06-23 06:12:24.893116
1486	1	46	3:0	0	0	\N	2026-06-23 06:57:30.742358
5	2	3	3:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 16:48:30.709849
7	2	5	1:4	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 16:48:43.994686
13	1	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 16:49:58.611706
8	2	6	4:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 16:48:49.17243
14	1	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 16:50:04.659095
34	9	6	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:04:14.321965
1488	1	48	3:1	0	0	\N	2026-06-23 06:57:48.761939
468	23	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 19:16:39.026955
464	27	17	3:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-14 19:09:22.761292
465	2	15	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 19:15:30.127633
16	1	8	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 16:52:33.274102
677	28	17	3:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-16 15:27:33.84079
682	32	17	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-16 15:31:07.429577
523	36	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 06:34:51.131068
1490	37	48	3:1	0	0	\N	2026-06-23 07:08:14.905698
36	9	8	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:04:23.437253
508	21	18	1:4	4	0	{"base": 3, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 4, "grand_total": 4}	2026-06-15 06:28:28.118248
10	2	7	0:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 16:48:54.836961
15	1	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 16:51:13.046962
35	9	7	0:5	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:04:19.282083
51	8	8	1:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:16:19.373203
18	3	2	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 16:58:45.826622
1	1	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-10 16:48:07.179225
3	2	2	2:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-10 16:48:24.222939
30	9	2	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:03:53.230272
38	8	2	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:05:57.774121
9	1	3	1:1	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-10 16:48:53.632814
39	8	3	1:1	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-10 17:08:13.195883
1476	39	46	2:0	0	0	\N	2026-06-23 06:12:08.373605
154	29	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-10 20:27:20.012441
162	31	1	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 20:55:18.313854
169	32	1	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 20:56:03.90727
172	30	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-10 22:10:06.202416
381	11	14	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 08:02:42.348001
150	27	5	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 20:02:55.472361
180	32	2	2:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-10 22:49:28.081025
148	27	3	1:1	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-10 20:02:41.387657
376	21	16	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 07:26:48.069609
149	27	4	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-10 20:02:46.920188
175	30	4	3:2	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-10 22:11:17.015153
151	27	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 20:03:04.459824
773	27	28	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-17 11:38:57.616641
177	30	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 22:11:37.958077
313	12	6	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 11:00:28.940601
145	11	8	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 19:19:12.717365
379	11	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 08:02:24.701045
683	32	18	0:6	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-16 15:31:16.092621
679	28	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 15:27:53.874994
684	32	19	3:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 3, "grand_total": 4}	2026-06-16 15:31:28.391124
153	27	8	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 20:04:20.939444
152	27	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 20:04:13.980686
314	12	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 11:03:42.80542
53	10	8	0:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:19:59.497321
75	18	8	1:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:35:01.184785
76	17	8	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:35:01.568012
88	14	8	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:41:24.709173
96	4	8	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:43:07.84382
107	22	8	1:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:46:13.249092
115	21	8	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:54:34.811587
123	23	8	0:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 18:01:43.522092
137	25	8	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 18:42:55.522666
170	31	8	0:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 20:56:04.2606
196	16	8	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-11 09:03:13.065516
199	26	8	0:4	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-11 09:10:05.54536
1478	21	50	3:0	0	0	\N	2026-06-23 06:26:28.212686
171	28	1	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 20:56:16.301545
156	29	3	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 20:32:20.024635
389	35	16	1:1	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-14 08:41:17.810244
131	26	4	0:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 18:35:21.374853
45	8	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-10 17:09:46.510312
65	17	4	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:33:51.932068
69	18	4	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-10 17:34:19.227333
84	14	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:39:51.496106
92	4	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-10 17:42:14.349327
103	22	4	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:45:09.59936
109	21	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:49:10.247139
119	23	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:59:09.037957
133	25	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 18:38:27.055571
141	11	4	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 19:17:17.388319
157	29	4	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 20:33:52.576043
192	16	4	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 09:02:36.832638
203	36	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 09:42:43.89688
210	37	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-11 11:08:11.716763
216	19	4	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 14:35:42.580085
222	33	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-11 17:08:21.417211
238	12	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 21:25:16.246871
260	32	4	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 15:40:23.47523
264	39	4	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 16:09:57.60954
288	28	4	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 21:04:23.014685
166	31	5	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 20:55:47.792724
167	31	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 20:55:53.557844
473	28	13	5:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 20:18:59.188909
362	10	15	2:4	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 01:12:44.221163
179	30	8	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 22:12:03.797348
168	31	7	1:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 20:55:59.197185
686	2	24	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 15:41:50.553253
178	30	7	0:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 22:11:52.761026
327	39	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 14:18:49.116667
331	32	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 15:56:04.829251
319	21	12	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 11:11:45.097063
159	29	6	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 20:34:52.505065
161	29	8	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 20:37:38.516449
337	24	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 16:26:41.513336
343	37	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 20:55:13.4928
368	16	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 01:32:30.288872
1479	21	51	3:1	0	0	\N	2026-06-23 06:26:53.465094
1483	35	47	0:3	0	0	\N	2026-06-23 06:42:15.588394
1489	37	47	0:2	0	0	\N	2026-06-23 07:08:03.218251
165	31	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 20:55:41.823103
184	35	4	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 06:22:02.438276
188	35	8	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-11 06:22:37.405287
325	30	12	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 12:38:18.745014
510	21	19	5:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 06:28:40.521629
781	8	23	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 12:54:21.955814
764	26	28	3:4	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-17 10:44:33.473166
160	29	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 20:36:18.240558
2	2	1	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 16:48:19.497962
17	3	1	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 16:58:40.621705
20	4	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-10 17:00:21.205672
29	9	1	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:03:48.092751
37	8	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-10 17:05:52.921996
40	10	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-10 17:09:11.611641
52	12	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-10 17:18:46.794286
58	17	1	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:32:30.957803
61	18	1	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:33:39.73032
62	14	1	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:33:42.46208
81	19	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-10 17:38:57.410878
100	22	1	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:44:55.526533
108	21	1	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:46:38.448775
116	23	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-10 17:57:20.372734
124	24	1	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 18:18:19.0842
125	25	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-10 18:29:47.529708
126	26	1	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 18:33:51.126807
138	11	1	2:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-10 19:15:43.995836
181	35	1	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-11 06:21:37.513372
189	16	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-11 08:45:01.713764
173	30	2	1:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 22:10:15.837636
146	27	1	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 20:02:24.971907
200	36	1	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 09:35:08.200619
208	37	1	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-11 11:07:47.348088
213	33	1	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 14:00:54.673281
224	38	1	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 17:51:04.125172
227	39	1	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 18:09:33.102051
255	33	7	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 14:49:45.497529
245	9	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 08:18:49.321473
243	14	10	1:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-12 06:59:45.998073
1480	21	52	1:3	0	0	\N	2026-06-23 06:27:09.365438
1482	35	46	5:1	0	0	\N	2026-06-23 06:41:58.419296
318	21	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 11:11:26.497895
295	17	12	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 05:44:02.571954
400	29	16	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:21:52.353822
1484	35	48	2:1	0	0	\N	2026-06-23 06:42:31.715535
41	10	2	1:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:09:21.446444
54	12	2	2:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-10 17:20:05.746139
79	14	2	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:37:09.90885
101	22	2	0:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 17:44:59.330779
467	2	17	5:1	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-14 19:15:53.860207
480	25	17	3:1	6	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 6, "grand_total": 6}	2026-06-14 20:48:59.625158
505	21	17	4:2	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-15 06:27:53.486256
511	35	17	4:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 06:29:19.914213
668	9	17	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 13:52:32.6769
147	27	2	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-10 20:02:34.392345
676	31	17	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 14:31:12.597283
687	23	17	2:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-16 15:46:15.087637
700	33	17	3:1	6	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 6, "grand_total": 6}	2026-06-16 18:13:30.874801
209	37	2	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-11 11:07:55.284965
702	3	17	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 18:38:40.68961
221	33	2	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-11 17:06:30.042109
228	39	2	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-11 18:11:34.651984
1487	1	47	1:2	0	0	\N	2026-06-23 06:57:41.152979
233	24	2	2:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-11 21:15:33.22715
725	12	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-16 22:41:19.30464
688	23	18	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-16 15:46:55.097388
707	31	18	0:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-16 21:02:37.793602
706	18	25	1:1	5	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 4, "grand_total": 5}	2026-06-16 20:05:06.105369
326	39	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 14:18:29.38583
487	29	17	2:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-14 22:00:39.796199
496	37	18	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-14 22:18:54.087482
63	17	3	2:2	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-10 17:33:44.278884
68	18	3	1:1	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-10 17:34:10.307173
499	18	18	0:4	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-14 22:44:09.579737
94	4	3	0:0	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-10 17:42:23.980112
704	3	19	1:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 18:38:56.564808
708	31	19	3:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-16 21:03:09.044811
129	26	3	1:1	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-10 18:34:49.465166
1481	35	45	4:1	0	0	\N	2026-06-23 06:41:34.043866
776	14	22	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 12:17:34.841293
361	10	14	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 01:12:36.815705
799	33	22	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 15:54:29.697276
800	28	22	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 16:30:32.074644
211	37	3	1:1	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-11 11:12:35.364365
803	3	22	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 16:52:11.121342
821	12	22	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 18:18:16.878987
822	17	22	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 18:54:15.15871
621	2	23	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 21:57:06.268914
254	33	3	1:1	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-12 14:49:21.963609
626	37	23	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 22:32:43.096755
631	1	23	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-15 22:43:39.268641
387	35	14	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 08:40:29.203199
638	27	23	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 23:42:09.556479
640	30	23	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-15 23:46:04.343927
642	29	23	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-16 00:07:43.630909
643	22	23	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 08:30:14.576968
784	16	23	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 13:11:21.8265
286	3	7	0:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-12 20:46:17.454069
334	24	7	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 16:25:43.737809
207	36	8	1:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-11 09:47:29.589317
220	19	8	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-11 16:31:01.809388
223	33	8	1:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-11 17:09:02.679289
270	37	8	1:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-12 18:41:25.768191
1142	8	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 15:26:15.281123
493	8	17	3:1	6	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 6, "grand_total": 6}	2026-06-14 22:13:47.284448
490	37	14	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 22:10:30.062593
393	19	16	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:02:21.862328
498	18	17	3:1	5	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 5, "grand_total": 5}	2026-06-14 22:44:00.881975
516	26	17	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 06:30:11.58773
779	14	23	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 12:25:09.285339
1491	37	50	2:1	0	0	\N	2026-06-23 07:08:26.175995
494	8	18	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-14 22:15:16.783044
517	26	18	1:3	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-15 06:30:27.974494
513	35	19	5:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 2, "grand_total": 3}	2026-06-15 06:29:41.995224
710	4	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-16 21:05:25.195317
720	33	19	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 21:09:23.023968
854	23	24	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 22:09:09.39122
1493	37	52	0:3	0	0	\N	2026-06-23 07:08:55.027779
1503	17	50	2:0	0	0	\N	2026-06-23 08:10:11.882685
851	30	30	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 21:50:14.835653
712	4	21	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 21:05:44.427255
726	12	21	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 22:41:29.253089
287	3	8	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-12 20:46:29.080972
308	28	8	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-13 09:49:44.294816
315	12	8	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-13 11:05:39.967119
328	39	8	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-13 14:19:16.225383
335	24	8	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-13 16:26:18.81866
345	32	8	0:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-13 21:36:57.684218
301	19	12	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 08:25:56.59213
645	18	23	1:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-16 08:30:42.838097
655	19	23	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-16 09:41:27.957085
659	35	23	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-16 09:49:16.902093
666	25	23	1:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-16 13:23:33.482842
674	9	23	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 13:53:15.012874
692	36	23	1:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-16 15:50:48.417023
716	4	23	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 21:06:17.739926
731	10	23	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 00:05:27.696099
834	31	23	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 20:23:15.70315
857	32	23	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 22:15:57.368204
861	2	28	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-17 22:30:27.874688
895	14	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 07:48:29.865855
273	38	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 19:49:22.922197
372	26	16	0:0	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-14 06:22:47.682509
462	24	17	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 18:29:12.790365
49	8	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:13:46.620525
271	37	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 18:41:44.706701
495	37	17	3:1	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-14 22:18:33.242788
525	1	17	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-15 06:55:51.812087
105	22	6	2:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:45:28.171268
1492	37	51	3:0	0	0	\N	2026-06-23 07:08:41.81402
791	23	21	4:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 15:18:34.248347
500	22	18	0:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-14 23:08:45.026789
518	26	19	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 06:30:36.233467
527	1	19	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 06:56:13.641326
528	1	20	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 06:56:41.001212
711	4	20	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 21:05:35.629726
246	19	10	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 10:08:36.476077
1494	37	49	1:2	0	0	\N	2026-06-23 07:09:06.920983
66	17	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:34:01.136035
353	2	12	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 00:17:09.928144
350	1	14	3:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 00:10:03.066285
375	21	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 07:25:36.311593
1498	16	49	1:0	0	0	\N	2026-06-23 07:18:59.801383
714	4	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 21:05:58.871133
811	24	27	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-17 17:18:11.370362
718	38	21	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 21:08:49.603897
403	4	12	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 09:35:09.165877
595	24	22	2:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-15 20:06:06.945949
604	22	22	0:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-15 21:20:23.005085
606	29	22	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-15 21:41:18.520381
620	2	22	4:2	5	0	{"base": 3, "high_score": 2, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 5, "grand_total": 5}	2026-06-15 21:56:58.906458
801	28	23	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 16:30:40.279266
850	30	29	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 21:49:50.216019
232	22	9	5:1	3	0	{"base": 1, "high_score": 2, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-11 21:13:22.162863
235	4	9	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 21:19:03.069293
237	29	9	5:0	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-11 21:23:38.27853
239	2	9	6:0	3	0	{"base": 1, "high_score": 2, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-11 21:28:59.845116
377	22	15	2:2	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-14 07:32:32.465418
463	4	17	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-14 18:43:29.885132
291	11	11	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 21:20:35.682732
833	22	30	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 20:05:56.188925
277	24	4	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 19:50:28.513442
283	3	4	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 20:45:37.155191
198	26	7	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 09:09:45.632302
417	14	12	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 10:59:12.566934
278	38	8	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 19:50:35.482946
248	1	10	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 10:28:22.936797
346	22	14	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 00:07:57.13058
275	38	6	1:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-12 19:50:10.001742
285	3	6	1:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-12 20:46:07.073808
438	11	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 16:10:22.612111
378	22	16	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 07:33:34.787619
47	10	7	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:10:10.180215
50	8	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:13:55.360036
73	17	7	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:34:50.595928
74	18	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:34:53.488683
87	14	7	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:40:54.758362
98	4	7	0:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-10 17:43:19.595045
106	22	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-10 17:46:06.797764
114	21	7	1:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 17:52:18.400172
122	23	7	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 18:00:51.235968
136	25	7	0:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 18:42:00.467709
144	11	7	0:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-10 19:18:46.902215
187	35	7	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 06:22:30.624573
195	16	7	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 09:02:59.167011
206	36	7	0:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 09:46:13.838063
212	37	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 11:12:45.764994
219	19	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 16:30:48.903485
276	38	7	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-12 19:50:22.485084
307	28	7	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 09:49:35.186245
450	38	12	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 17:26:12.297803
724	2	25	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 21:41:45.966389
231	19	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-11 19:06:46.616543
241	18	9	6:0	3	0	{"base": 1, "high_score": 2, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-11 22:14:08.306247
242	9	9	5:0	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-11 22:28:35.943354
244	14	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 07:00:52.27256
247	1	9	5:0	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-12 10:28:03.870395
249	25	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 13:16:03.935325
251	8	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 14:13:37.248286
258	33	9	5:0	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-12 14:52:49.066961
266	16	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-12 18:36:09.702918
279	38	9	5:0	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-12 19:50:51.147995
292	17	9	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 05:43:31.863397
309	26	9	4:1	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-13 10:17:54.24919
316	21	9	5:0	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-13 11:10:44.392384
320	23	9	5:0	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-13 11:55:32.394997
322	30	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 12:36:21.878389
336	24	9	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 16:26:30.363923
340	36	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 17:59:20.326765
356	12	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 00:40:25.728738
358	10	9	5:0	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-14 01:12:11.71081
382	35	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 08:32:36.436759
420	32	9	5:0	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-14 11:23:35.53923
426	27	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 12:49:07.436747
437	31	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 15:30:39.91263
439	39	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 16:44:34.895936
443	3	9	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 16:45:14.322832
502	22	17	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-15 02:11:42.249039
521	36	17	3:0	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-15 06:34:27.472832
256	33	10	1:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-12 14:50:22.884026
267	16	10	2:2	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-12 18:36:17.719878
1495	16	47	0:3	0	0	\N	2026-06-23 07:18:27.371709
280	38	10	1:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-12 19:51:06.956109
501	22	19	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-14 23:08:55.900889
817	29	29	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 18:05:39.610337
729	10	21	5:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 00:03:30.123313
808	24	24	0:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 17:17:29.009501
794	36	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 15:27:45.82531
810	24	26	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-17 17:17:54.261997
1496	16	48	2:1	0	0	\N	2026-06-23 07:18:37.148467
488	29	18	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-14 22:00:46.802758
806	3	21	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	\N
1180	1	37	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 16:59:33.377217
444	3	10	1:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-14 16:45:21.811231
380	11	12	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 08:02:35.280824
407	4	16	1:1	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-14 09:35:46.171547
298	18	12	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-13 07:29:32.791874
304	29	12	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 09:37:15.006949
312	26	12	3:2	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-13 10:18:34.920916
329	22	12	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 15:03:58.04961
339	24	12	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 16:27:24.489322
342	37	12	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-13 20:55:07.78688
348	1	12	3:2	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-14 00:09:49.998615
363	10	12	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-14 01:13:01.614845
365	16	12	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-14 01:31:54.714779
386	35	12	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 08:35:38.739746
395	8	12	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 09:13:31.878738
414	36	12	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 10:09:29.680461
424	9	12	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 12:48:59.66725
432	27	12	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 14:00:51.080206
442	39	12	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 16:45:10.566709
446	3	12	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-14 16:45:40.63838
738	39	23	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 06:34:52.959955
747	21	23	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 07:43:09.389387
759	26	23	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 10:42:04.094742
793	23	23	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 15:18:47.314158
804	3	23	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 16:52:16.902362
807	24	23	1:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-17 17:17:17.780976
823	17	23	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-17 18:54:24.487605
836	38	23	1:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-17 20:50:22.974939
855	12	23	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-17 22:09:36.763574
864	33	23	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 22:38:28.056285
646	18	24	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 08:30:55.905475
860	2	27	0:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 22:30:20.762968
849	30	28	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 21:49:22.999714
504	19	17	4:2	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-15 04:42:39.191267
294	17	11	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-13 05:43:53.107307
297	18	11	1:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-13 07:29:22.708847
661	25	18	0:3	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 13:22:09.548588
669	9	18	0:5	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-16 13:52:37.817749
678	28	18	0:6	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-16 15:27:44.147788
696	14	18	1:4	4	0	{"base": 3, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 4, "grand_total": 4}	2026-06-16 17:56:00.87145
347	1	11	2:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-14 00:09:39.250121
352	2	11	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 00:16:58.598989
359	10	11	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 01:12:19.588452
364	16	11	1:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-14 01:31:41.929501
703	3	18	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-16 18:38:50.616586
709	4	18	1:3	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 21:05:16.919517
719	33	18	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-16 21:09:00.633889
650	12	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 08:44:20.58049
662	25	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-16 13:22:21.109929
422	32	11	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-14 11:24:47.184871
670	9	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 13:52:48.690971
433	27	11	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-14 14:01:07.041239
689	23	19	3:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-16 15:47:12.723471
445	3	11	1:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-14 16:45:28.706408
449	38	11	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-14 17:25:35.337219
453	31	11	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-14 18:02:27.749876
697	14	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 17:56:54.676085
471	28	11	0:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-14 20:18:38.269298
474	25	11	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 20:46:05.665355
481	33	11	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-14 20:49:23.413966
1497	16	50	1:0	0	0	\N	2026-06-23 07:18:46.182449
411	18	16	1:1	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-14 10:02:12.206378
478	25	16	1:1	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-14 20:48:43.347513
430	9	16	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 12:49:46.633099
436	27	16	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 14:02:57.950577
461	24	16	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 18:28:51.893075
466	2	16	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 19:15:39.264916
470	1	16	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 19:32:02.118087
492	8	16	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 22:13:34.673833
1501	31	45	3:0	0	0	\N	2026-06-23 07:31:49.300261
454	31	12	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 18:03:39.421223
456	12	12	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 18:25:06.793078
469	23	12	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 19:18:04.496089
472	28	12	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 20:18:49.794409
475	25	12	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-14 20:47:07.618801
485	33	12	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-14 20:53:23.61544
491	32	12	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 22:13:23.133128
843	38	30	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-17 20:51:56.584774
536	38	16	1:1	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-15 08:17:24.479705
1499	16	51	3:0	0	0	\N	2026-06-23 07:19:08.305779
565	30	16	2:2	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-15 16:24:58.031274
600	32	16	1:1	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-15 20:58:07.500106
4	1	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 16:48:30.374355
60	17	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:33:35.589982
64	18	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:33:47.692711
99	4	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:44:09.123705
112	21	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:49:53.718262
117	23	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:57:34.093442
127	26	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 18:34:00.548484
128	25	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 18:34:06.681715
139	11	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 19:16:15.366419
155	29	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 20:29:52.447445
163	31	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 20:55:24.540738
182	35	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 06:21:44.896829
190	16	2	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 08:50:00.720192
201	36	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 09:38:28.02251
214	19	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 14:35:21.294431
570	30	21	5:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 16:25:58.549937
580	2	21	5:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 18:58:04.557476
588	26	21	4:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 19:29:36.597079
594	24	21	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 20:05:57.702467
605	29	21	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 21:41:08.734462
613	11	21	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 21:52:33.168609
734	18	27	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-17 06:20:53.626486
749	1	28	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 08:05:43.851193
756	11	26	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 08:17:23.82434
1500	16	52	0:1	0	0	\N	2026-06-23 07:19:14.558504
529	1	18	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 06:57:30.388135
225	38	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 17:51:16.339648
229	28	2	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 18:49:23.92901
46	10	6	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:10:03.965516
71	18	6	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:34:47.012333
86	14	6	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:40:35.706603
111	21	6	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:49:32.464669
121	23	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 18:00:04.433257
135	25	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 18:40:52.634685
143	11	6	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 19:18:19.729212
186	35	6	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 06:22:22.727808
194	16	6	3:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 09:02:52.435517
197	26	6	1:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 09:09:30.010684
205	36	6	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 09:45:35.746041
218	19	6	4:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 16:29:44.441685
236	4	6	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 21:19:12.52016
257	33	6	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 14:52:12.021337
269	37	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 18:41:10.755028
306	28	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 09:49:21.706226
330	32	6	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 15:55:58.701613
333	24	6	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 16:24:25.512768
250	25	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 13:16:10.466972
252	8	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 14:20:43.108189
262	4	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 16:06:00.42562
272	37	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 18:41:51.404427
281	22	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 20:36:05.884268
290	11	10	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 21:17:38.986612
293	17	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 05:43:40.876649
296	18	10	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 07:29:13.043174
299	10	10	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 08:22:10.888807
302	29	10	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 09:36:23.492354
310	26	10	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 10:18:05.82947
317	21	10	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 11:10:54.058941
321	23	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 11:55:47.974132
323	30	10	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 12:37:45.970724
1502	31	46	3:1	0	0	\N	2026-06-23 07:33:36.626202
19	3	3	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 16:59:04.095797
31	9	3	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:03:57.351478
42	10	3	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:09:29.097327
55	12	3	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:24:36.627619
82	14	3	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:39:02.712967
102	22	3	0:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:45:04.871119
113	21	3	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:52:01.525997
118	23	3	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:58:09.196508
132	25	3	0:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 18:37:09.420878
140	11	3	0:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 19:16:43.782916
164	31	3	0:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 20:55:35.94253
174	30	3	0:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 22:10:53.921044
183	35	3	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 06:21:54.495069
191	16	3	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 09:02:23.022632
202	36	3	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 09:40:45.904056
215	19	3	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 14:35:33.399518
226	38	3	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 17:51:30.849016
230	28	3	0:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 18:49:41.933777
234	24	3	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 21:16:15.269121
259	32	3	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 15:40:09.990309
263	39	3	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 16:09:03.05723
33	9	5	0:4	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:04:09.187825
44	10	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:09:42.661333
48	8	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:12:20.899791
67	17	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:34:07.862413
70	18	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:34:31.930965
85	14	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:40:28.107924
90	4	5	0:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:42:06.842857
104	22	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:45:17.101804
110	21	5	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:49:23.826547
120	23	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 17:59:30.629567
130	26	5	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 18:35:11.352642
134	25	5	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 18:39:40.066558
142	11	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 19:17:33.146094
750	1	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 08:05:52.0691
852	27	30	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 21:50:30.680012
573	18	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 17:01:53.804094
614	11	22	2:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-15 21:52:41.856556
537	38	17	3:1	6	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 6, "grand_total": 6}	2026-06-15 08:17:35.198395
546	16	17	3:1	5	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 5, "grand_total": 5}	2026-06-15 10:19:40.953299
615	11	23	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 21:52:53.38494
158	29	5	0:4	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 20:34:43.796814
556	10	17	3:0	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-15 12:25:24.397577
532	28	14	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 07:59:37.749786
533	28	16	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 08:00:56.177106
566	30	17	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-15 16:25:12.382945
649	12	17	2:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-16 08:44:05.740802
618	2	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 21:56:24.24494
512	35	18	1:4	5	0	{"base": 3, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 4, "grand_total": 5}	2026-06-15 06:29:30.665128
522	36	18	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 06:34:42.573617
538	38	18	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 08:17:47.756018
547	16	18	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 10:19:49.650276
553	19	18	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 12:00:01.80608
557	10	18	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 12:25:39.450343
567	30	18	0:3	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-15 16:25:26.192697
617	2	18	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 21:56:13.105048
539	38	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 08:18:01.396117
543	29	19	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 10:00:49.237141
548	16	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 10:20:01.909076
554	19	19	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 12:00:50.827967
558	10	19	3:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-15 12:25:47.092314
568	30	19	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 16:25:37.217683
503	22	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 02:11:54.775584
514	21	20	4:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 06:29:49.157007
515	35	20	3:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-15 06:29:52.422386
519	26	20	1:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 06:31:02.134352
524	36	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 06:35:05.393038
544	29	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 10:01:48.133168
549	16	20	3:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 10:20:12.196461
562	36	21	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 16:15:20.97568
652	19	20	1:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-16 09:41:00.021381
584	39	17	3:0	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-15 19:26:09.421107
603	14	17	3:1	6	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 6, "grand_total": 6}	2026-06-15 21:09:26.863883
609	11	17	3:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-15 21:48:37.852549
663	25	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-16 13:22:28.707008
1504	22	50	2:1	0	0	\N	2026-06-23 08:13:37.715422
589	26	22	2:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-15 19:30:14.869404
585	39	18	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 19:26:20.116624
591	24	18	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 20:04:49.619918
1508	17	49	2:2	0	0	\N	2026-06-23 08:14:34.486263
875	10	31	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-18 01:06:38.840575
1509	17	51	3:0	0	0	\N	2026-06-23 08:14:42.66013
1510	17	52	1:2	0	0	\N	2026-06-23 08:14:57.236757
671	9	20	3:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-16 13:52:54.482525
608	11	18	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 21:48:26.838322
370	26	14	2:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-14 06:22:03.806221
648	12	18	0:5	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-16 08:43:48.289443
586	39	19	3:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-15 19:26:34.951924
592	24	19	1:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 20:05:20.236584
611	11	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 21:50:59.861783
559	10	20	3:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 12:25:55.683712
569	30	20	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-15 16:25:47.772596
587	39	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 19:26:45.650692
590	18	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-15 19:51:22.545343
593	24	20	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 20:05:40.790356
612	11	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 21:52:24.372449
619	2	20	3:1	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 3, "grand_total": 4}	2026-06-15 21:56:35.489954
628	37	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 22:33:03.037064
680	28	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-16 15:28:06.742793
685	32	20	3:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-16 15:31:37.302036
583	39	16	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 19:25:59.530247
596	12	16	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 20:39:40.180404
576	22	21	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 18:00:59.117554
355	2	14	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 00:17:31.519917
367	16	14	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 01:32:17.76844
374	21	14	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 07:25:10.612101
391	19	14	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:01:55.619723
886	26	29	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 05:39:26.777304
889	26	32	1:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-18 06:02:25.907488
1505	22	49	2:2	0	0	\N	2026-06-23 08:13:50.662481
1506	22	51	4:1	0	0	\N	2026-06-23 08:14:02.023414
176	30	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-10 22:11:28.907002
185	35	5	1:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 06:22:16.140626
193	16	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 09:02:44.844255
204	36	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 09:43:58.370639
217	19	5	1:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 14:35:53.862498
240	12	5	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-11 21:51:40.88233
253	33	5	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 14:49:05.473434
261	32	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 15:40:34.920458
265	39	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 16:10:13.501395
268	37	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 18:41:03.107336
274	38	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 19:49:55.132811
284	3	5	1:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 20:45:49.337267
305	28	5	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 09:49:10.939846
332	24	5	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 16:24:06.684759
282	22	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-12 20:36:59.589692
300	19	11	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 08:25:44.073581
303	29	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 09:36:39.908128
311	26	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 10:18:15.695587
324	30	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 12:38:01.372136
384	35	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 08:33:28.809149
394	8	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:13:11.710349
402	4	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:35:02.901661
413	36	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 10:09:23.251175
416	14	11	0:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 10:47:07.930238
423	9	11	0:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 12:48:44.123946
441	39	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 16:44:56.768546
455	12	11	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 18:23:25.736713
341	17	13	5:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 20:31:14.828183
344	37	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 20:55:24.175377
349	1	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 00:09:57.184648
354	2	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 00:17:15.814311
360	10	13	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 01:12:26.503073
647	22	24	1:3	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-16 08:30:56.304025
653	19	21	3:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 09:41:06.910246
1507	22	52	0:3	0	0	\N	2026-06-23 08:14:09.932452
1519	12	45	2:1	0	0	\N	2026-06-23 09:36:43.446327
627	37	21	4:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 22:32:52.444164
625	37	22	2:0	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-15 22:32:36.160269
622	8	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 22:30:01.369176
338	24	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-13 16:27:05.683717
351	2	10	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 00:15:36.661163
357	12	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 00:41:03.738779
383	35	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 08:32:49.573428
412	36	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 10:09:05.145765
421	32	10	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 11:24:35.05556
427	27	10	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 12:49:15.982071
440	39	10	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 16:44:43.921762
447	28	10	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 17:04:00.607151
448	31	10	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 17:25:34.925815
396	8	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:15:01.434055
397	29	13	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:18:50.190056
404	4	13	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:35:17.726615
408	18	13	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 10:01:36.396662
415	22	13	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 10:43:45.77839
418	14	13	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 10:59:19.829977
425	9	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 12:49:06.710491
431	27	13	5:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 14:00:44.910276
451	38	13	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 17:26:31.937254
457	12	13	5:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 18:26:22.314268
458	24	13	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 18:28:10.132845
476	25	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 20:47:13.124421
482	33	13	5:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 20:51:46.167052
506	36	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 06:28:13.215807
530	3	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 07:31:32.141504
540	31	13	5:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 09:15:09.288983
550	23	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 11:06:04.213602
560	32	13	5:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 14:53:52.557906
398	29	14	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:19:37.418051
401	8	14	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:27:33.259151
405	4	14	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:35:30.38558
388	35	15	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 08:40:51.587846
630	1	22	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-15 22:42:28.302996
632	8	22	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-15 22:52:41.353114
637	27	22	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-15 23:41:24.940265
1190	39	34	2:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-20 19:00:55.046391
1511	3	45	3:0	0	0	\N	2026-06-23 08:32:03.347249
639	30	22	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 23:45:25.500071
366	16	13	5:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 01:32:05.129352
392	19	15	1:1	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-14 09:02:03.168396
748	21	24	1:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 07:43:22.900403
633	27	18	1:5	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-15 23:39:55.136634
629	37	19	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-15 22:33:09.450208
634	27	19	3:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 2, "grand_total": 3}	2026-06-15 23:40:08.692154
623	8	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 22:30:49.203596
635	27	20	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-15 23:40:34.774649
690	23	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-16 15:47:45.031201
698	14	20	3:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-16 17:57:18.079305
526	1	15	1:1	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-15 06:56:03.919899
705	3	20	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-16 18:39:02.090479
717	38	20	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-16 21:08:35.823571
721	33	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-16 21:09:45.684489
722	31	20	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-16 21:10:01.711314
575	1	21	4:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 17:58:41.710873
616	18	21	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 21:55:14.539727
369	26	13	4:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 06:21:51.270716
373	21	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 07:23:24.365196
385	35	13	6:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 08:33:51.472015
390	19	13	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:01:46.884936
371	26	15	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 06:22:14.57015
624	8	21	4:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 22:30:56.349219
636	27	21	5:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 23:40:50.530858
657	35	21	4:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 09:47:42.809039
664	25	21	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 13:22:35.598106
672	9	21	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 13:53:02.528918
681	28	21	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 15:28:19.385214
694	16	21	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 16:47:33.678324
882	21	29	5:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 02:04:39.760046
409	18	14	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 10:01:54.433232
419	14	14	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 11:01:37.132426
428	9	14	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 12:49:32.682337
434	27	14	4:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 14:01:34.116039
452	38	14	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 17:26:46.596959
459	24	14	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 18:28:29.957924
477	25	14	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 20:47:29.491114
507	36	14	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 06:28:23.591466
531	3	14	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 07:31:38.439978
541	31	14	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 09:15:26.767095
551	23	14	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 11:06:36.621494
561	32	14	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 14:54:05.875568
563	30	14	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 16:24:17.244478
574	12	14	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 17:57:39.460362
577	33	14	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 18:02:31.22194
497	37	16	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 22:19:01.288121
520	36	16	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 06:31:26.101882
542	31	16	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 09:16:18.665071
545	16	16	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 10:19:29.04839
555	10	16	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 12:25:18.7198
598	3	16	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 20:51:29.771861
602	14	16	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 21:08:45.794233
607	23	16	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 21:45:40.076806
610	11	16	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 21:48:50.854989
641	33	16	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 00:06:05.95028
1512	3	46	2:0	0	0	\N	2026-06-23 08:32:08.757996
1515	18	50	1:0	0	0	\N	2026-06-23 09:13:57.817125
699	14	21	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 17:58:32.764283
736	39	21	5:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 06:34:06.249664
740	17	21	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 06:39:06.632192
745	21	21	5:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 07:42:15.148818
765	32	21	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 10:59:45.201327
777	31	21	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 12:20:58.378884
798	33	21	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 15:54:20.537299
644	18	22	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 08:30:27.457304
654	19	22	4:3	3	0	{"base": 1, "high_score": 2, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-16 09:41:18.49562
757	29	28	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 08:17:29.644836
399	29	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:21:04.501568
406	4	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 09:35:39.186679
410	18	15	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 10:02:04.813935
429	9	15	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 12:49:38.448571
435	27	15	1:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 14:02:49.360646
460	24	15	0:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 18:28:41.707748
479	25	15	1:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 20:48:50.434896
486	8	15	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 21:01:02.308794
489	37	15	1:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-14 22:10:22.513293
509	36	15	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 06:28:30.850052
534	28	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 08:03:12.033153
535	38	15	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 08:17:10.68106
552	23	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 11:08:18.550668
564	30	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 16:24:27.297203
578	33	15	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 18:02:56.057697
579	12	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 18:10:43.246277
581	31	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 19:09:51.710957
582	39	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 19:25:45.667481
597	3	15	0:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 20:51:22.262554
599	32	15	0:3	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 20:57:46.701763
601	14	15	0:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-15 21:08:13.354423
1513	3	47	0:3	0	0	\N	2026-06-23 08:32:14.94401
1514	3	48	2:1	0	0	\N	2026-06-23 08:32:21.246906
761	26	25	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 10:43:55.34697
772	27	27	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 11:38:47.976467
658	35	22	3:2	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-16 09:49:03.075418
665	25	22	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 13:22:47.72081
673	9	22	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 13:53:07.291209
691	36	22	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 15:50:33.262293
695	16	22	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 16:47:39.673722
713	4	22	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 21:05:50.31946
730	10	22	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 00:03:38.878728
737	39	22	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 06:34:21.706193
746	21	22	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 07:42:52.581595
766	32	22	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 10:59:54.771595
778	31	22	2:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-17 12:21:50.069152
792	23	22	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 15:18:40.989336
651	29	24	0:4	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 08:55:47.200352
656	19	24	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 09:41:37.960851
660	35	24	1:4	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 09:49:26.917292
667	25	24	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 13:23:39.918474
675	9	24	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-16 13:53:25.361339
693	36	24	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-16 15:50:57.18685
701	11	24	1:3	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-16 18:18:44.965029
715	4	24	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 21:06:06.694885
723	1	24	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 21:19:58.241023
732	10	24	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 00:05:39.954019
739	39	24	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 06:35:04.18511
760	26	24	1:3	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-17 10:42:35.689427
771	27	24	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 11:38:22.409815
780	14	24	1:3	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-17 12:25:18.326746
782	8	24	1:3	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-17 12:54:28.614948
785	16	24	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 13:11:30.335919
802	28	24	0:3	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 16:30:52.340078
805	3	24	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 16:52:23.13294
814	37	24	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 18:03:13.669081
824	17	24	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 18:54:32.29307
835	31	24	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 20:23:45.310946
837	38	24	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 20:50:40.487894
844	30	24	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 21:46:07.61314
853	12	24	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 22:07:39.252631
858	32	24	0:3	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 22:16:23.315497
865	33	24	0:3	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 22:39:07.188871
863	2	30	2:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 22:30:45.060984
868	18	30	0:2	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 2, "streak_len": 9, "match_total": 1, "grand_total": 3}	2026-06-18 00:17:26.934394
874	10	30	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 01:06:29.343772
883	21	30	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 02:04:55.959754
887	26	30	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 05:39:37.861995
891	19	30	1:3	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-18 06:46:24.797114
904	35	30	1:4	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-18 08:22:59.813978
919	8	30	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 11:55:24.355281
932	25	30	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-18 14:57:38.62365
1516	18	49	2:2	0	0	\N	2026-06-23 09:15:55.05923
1518	18	52	0:2	0	0	\N	2026-06-23 09:16:20.520743
1526	28	45	3:0	0	0	\N	2026-06-23 10:14:04.183623
946	27	33	3:2	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-18 16:35:50.572296
1517	18	51	3:0	0	0	\N	2026-06-23 09:16:12.125064
911	2	31	3:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-18 09:34:27.829765
876	29	30	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 01:07:09.406739
921	8	32	3:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 11:58:22.590471
923	22	32	2:0	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 12:22:27.067063
1524	23	45	3:0	0	0	\N	2026-06-23 10:03:33.29853
1527	24	47	0:1	0	0	\N	2026-06-23 10:50:57.052124
1211	18	41	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 22:55:57.451363
727	29	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-16 22:56:37.317186
741	19	25	1:1	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 4, "grand_total": 4}	2026-06-17 07:22:57.824127
752	1	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 08:06:09.359901
758	11	25	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 08:17:43.043202
767	22	25	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 11:13:03.516827
774	27	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 11:39:08.525468
783	8	25	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 12:57:02.482651
786	16	25	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 13:11:40.817404
809	24	25	1:1	5	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 4, "grand_total": 5}	2026-06-17 17:17:37.025921
815	37	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 18:03:24.866162
825	17	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 18:54:45.355324
830	25	25	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 19:04:52.760589
838	38	25	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 20:50:56.216389
845	30	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 21:46:59.71412
856	12	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 22:13:53.845175
869	10	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 01:05:34.283268
878	21	25	1:1	4	0	{"base": 3, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 4, "grand_total": 4}	2026-06-18 02:01:41.719575
894	14	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 07:46:24.942004
898	39	25	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 08:06:33.164633
899	35	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 08:21:12.619153
913	32	25	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 11:46:54.049183
925	33	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 13:29:20.728838
926	3	25	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 14:54:07.583882
935	28	25	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 14:59:36.891872
908	39	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 08:31:09.72861
910	39	29	2:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 3, "grand_total": 4}	2026-06-18 08:32:19.744777
915	32	27	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 11:47:16.708069
897	14	28	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 07:51:58.608446
938	23	25	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 15:49:50.207616
943	31	25	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	\N
957	4	30	0:3	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-18 18:24:22.94191
953	4	26	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 18:23:45.806942
954	4	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 18:23:54.036556
967	31	27	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 20:36:51.878241
970	12	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 20:51:09.402447
971	12	28	1:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-18 20:51:14.789087
956	4	29	3:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-18 18:24:14.399039
963	11	29	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-18 18:55:55.92616
964	11	30	1:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-18 18:56:32.534466
992	16	30	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 06:26:41.705395
1000	36	30	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-19 06:31:08.269853
1003	17	30	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 07:01:07.393893
1048	14	30	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 17:24:29.855523
1050	28	30	0:3	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-19 17:25:38.476288
1056	32	30	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 18:15:02.638325
1058	31	30	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 18:17:51.574072
1059	12	30	1:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-19 19:27:52.540942
1062	23	30	1:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-19 20:29:51.712015
1065	39	30	0:1	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 3, "grand_total": 4}	2026-06-19 20:32:29.844258
1075	9	30	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 21:10:56.8887
951	38	31	5:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-18 18:15:03.793139
1076	9	31	3:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-19 21:11:02.546737
1084	31	31	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-19 23:28:12.473996
1520	12	46	3:1	0	0	\N	2026-06-23 09:39:31.814068
1521	12	47	0:3	0	0	\N	2026-06-23 09:39:42.429032
1130	23	34	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 13:40:32.881392
949	29	33	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 18:12:03.21711
952	38	33	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 18:15:18.009455
959	4	33	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 18:24:58.719862
976	22	33	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 22:25:05.265755
983	2	33	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 23:01:03.317538
987	19	33	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 05:37:13.573944
995	16	33	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 06:27:22.343654
1129	23	33	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 13:40:27.559849
1212	18	42	6:0	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-20 22:56:17.966592
968	28	27	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 20:50:38.987902
885	21	32	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 02:05:29.026793
893	19	32	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 06:46:50.772266
906	35	32	3:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 08:23:24.809346
934	25	32	1:0	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 14:59:08.276622
937	29	32	2:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 15:04:51.562684
945	27	32	2:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 16:35:37.811151
950	38	32	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 18:14:52.87277
960	4	32	2:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 18:25:15.28527
966	11	32	1:0	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 18:58:39.065652
980	2	32	1:0	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 22:59:40.891745
982	24	32	2:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 23:01:00.605916
994	16	32	3:0	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 06:27:11.183546
1002	36	32	2:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 06:41:09.247484
1005	17	32	2:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 07:01:30.283031
1020	37	32	3:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 07:14:59.025877
1038	30	32	2:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 13:39:57.907885
1054	14	32	3:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 17:28:06.890348
1061	12	32	2:0	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 19:29:11.601725
1064	23	32	2:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 20:31:25.752294
1069	39	32	2:0	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 20:34:45.881882
1077	9	32	2:0	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 21:11:08.558892
1085	31	32	2:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 23:28:47.509348
1086	28	32	2:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 23:32:13.489246
1097	33	32	1:0	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-20 01:47:53.775781
1522	2	47	0:2	0	0	\N	2026-06-23 09:53:15.650532
1523	2	48	3:1	0	0	\N	2026-06-23 09:53:28.506239
1525	23	46	3:0	0	0	\N	2026-06-23 10:03:42.434307
1109	18	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 08:11:15.556191
1006	17	33	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 07:01:36.783161
1021	37	33	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 07:15:09.788224
1025	18	33	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 07:23:13.918447
1032	25	33	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 12:00:17.200216
1039	30	33	3:2	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-19 13:41:23.397728
1125	4	34	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 12:19:15.056243
1087	29	38	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 00:05:46.08845
1110	18	40	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 08:11:31.484862
979	24	30	0:1	5	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 2, "streak_len": 9, "match_total": 3, "grand_total": 5}	2026-06-18 22:59:17.569455
1528	24	48	2:0	0	0	\N	2026-06-23 10:51:12.120537
973	18	32	3:1	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 21:07:40.658539
978	22	35	1:1	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-18 22:26:24.246887
728	29	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-16 22:57:18.536086
733	18	26	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-17 06:20:35.313113
742	19	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 07:25:14.101729
751	1	26	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 08:05:59.769145
762	26	26	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 10:44:05.936512
768	22	26	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-17 11:13:15.473698
775	27	26	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 11:40:23.707665
787	16	26	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 13:11:49.343365
789	8	26	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 13:19:42.574948
795	36	26	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 15:28:46.555644
816	37	26	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 18:03:38.978854
826	17	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 18:54:54.09181
831	25	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 19:05:01.085111
839	38	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 20:51:10.819249
846	30	26	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 21:48:02.083709
859	2	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 22:30:10.559914
870	10	26	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 01:05:46.797095
879	21	26	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-18 02:03:44.2005
900	35	26	3:2	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-18 08:21:37.33927
907	39	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 08:30:25.395626
914	32	26	0:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 11:47:05.726565
927	3	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 14:54:16.597139
936	28	26	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 14:59:56.900065
939	23	26	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 15:55:59.281454
947	31	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 17:46:00.191343
948	12	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 17:57:36.266015
941	23	28	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-18 16:00:30.691637
990	19	36	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 05:37:58.487241
985	2	35	6:7	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 23:01:57.095748
977	22	34	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 22:25:14.208027
1088	18	37	3:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-20 00:08:50.986252
961	33	26	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 18:28:35.250385
1529	24	50	2:1	0	0	\N	2026-06-23 10:51:25.777493
1116	12	34	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 09:18:11.812951
1014	3	29	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 07:09:14.41227
1011	1	30	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 07:03:34.635266
1015	3	30	0:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-19 07:09:19.726285
1121	35	34	5:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 10:44:39.401629
1164	36	34	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 16:21:08.795198
1012	1	31	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 07:03:43.686757
1090	32	32	3:0	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-20 00:55:45.07771
1045	8	33	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 16:46:46.159611
1067	21	33	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 20:34:23.907441
1073	1	33	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 21:10:25.814777
1078	9	33	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 21:11:19.528106
1098	26	33	3:2	3	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 2, "grand_total": 3}	2026-06-20 06:53:06.296145
1106	3	33	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 07:16:48.735264
1115	12	33	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 09:18:01.706391
1120	35	33	4:2	3	0	{"base": 1, "high_score": 2, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-20 10:44:33.634552
1128	32	33	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 13:22:26.210891
1131	24	33	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 14:29:29.009596
1136	33	33	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 15:20:26.350984
1143	14	33	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 15:35:29.715393
1151	11	33	3:2	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-20 15:56:23.618986
1163	36	33	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 16:17:58.610756
1167	31	33	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 16:28:43.248229
1177	28	33	3:2	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	\N
988	19	34	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 05:37:22.175196
996	16	34	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 06:27:27.640005
1007	17	34	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 07:01:45.184025
1026	18	34	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 07:24:13.350653
1029	29	34	3:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 07:55:02.715678
1033	25	34	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 12:01:20.018899
1040	30	34	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 13:41:37.809893
1153	22	37	4:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 2, "grand_total": 3}	2026-06-20 15:56:40.104898
1118	29	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 09:46:22.228953
1214	29	42	8:0	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-20 23:02:11.812658
743	19	27	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 07:25:23.059196
754	29	27	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 08:16:53.795322
755	11	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 08:17:09.49159
763	26	27	0:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 10:44:19.142345
769	22	27	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 11:13:58.145918
788	16	27	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 13:12:03.43785
790	8	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 13:19:51.527305
796	36	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 15:29:22.571516
820	37	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 18:07:46.171521
827	17	27	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 18:55:00.950988
832	25	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 19:05:06.941631
840	38	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 20:51:25.507584
847	30	27	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-17 21:48:35.060922
871	10	27	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 01:05:56.739325
880	21	27	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-18 02:04:07.888435
896	14	27	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 07:51:08.450533
901	35	27	4:1	2	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-18 08:22:12.861196
928	3	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 14:54:25.274561
940	23	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 15:56:36.227181
975	33	27	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 21:26:06.869077
1530	27	52	0:2	0	0	\N	2026-06-23 10:58:49.270344
735	18	28	2:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 2, "streak_len": 7, "match_total": 1, "grand_total": 3}	2026-06-17 06:21:22.37863
744	19	28	3:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-17 07:25:35.670873
753	11	28	2:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 2, "grand_total": 3}	2026-06-17 08:16:51.09012
770	22	28	2:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-17 11:14:11.815018
797	36	28	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 15:29:55.09165
812	24	28	2:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 2, "streak_len": 7, "match_total": 1, "grand_total": 3}	2026-06-17 17:18:28.510062
819	37	28	1:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-17 18:07:40.18241
828	17	28	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-17 18:55:09.926988
841	38	28	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-17 20:51:35.208005
872	10	28	1:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 01:06:04.609004
881	21	28	1:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 02:04:26.168469
902	35	28	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-18 08:22:28.909221
909	39	28	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-18 08:31:43.759948
916	32	28	2:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 11:47:27.881065
917	8	28	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 11:54:12.965437
1532	32	46	3:0	0	0	\N	2026-06-23 12:43:33.748179
1533	1	51	3:0	0	0	\N	2026-06-23 12:43:39.597278
929	3	28	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 14:54:38.126193
930	25	28	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-18 14:55:44.87055
955	4	28	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-18 18:24:02.334504
969	28	28	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 20:50:46.114958
974	33	28	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-18 21:09:38.021449
986	31	28	2:3	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-18 23:15:56.085785
1531	32	45	3:0	0	0	\N	2026-06-23 12:43:25.920138
1024	37	36	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 07:15:57.481993
1013	1	32	2:0	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-19 07:04:06.757777
1018	37	30	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-19 07:14:43.258068
1047	33	30	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 17:10:09.511667
1004	17	31	4:0	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 2, "grand_total": 3}	2026-06-19 07:01:16.391214
1017	3	32	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 07:09:32.893364
813	22	29	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-17 17:57:08.63461
818	37	29	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-17 18:07:30.296004
829	17	29	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-17 18:55:16.176102
842	38	29	3:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-17 20:51:43.703923
848	27	29	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 21:49:00.877011
862	2	29	4:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-17 22:30:36.759138
866	18	29	2:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 2, "streak_len": 8, "match_total": 1, "grand_total": 3}	2026-06-18 00:17:07.661195
873	10	29	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 01:06:15.330021
890	19	29	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-18 06:46:18.011926
903	35	29	2:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 3, "grand_total": 4}	2026-06-18 08:22:46.714594
918	8	29	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 11:55:10.161586
1010	1	29	0:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 07:03:27.26685
1036	23	29	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-19 13:19:45.567017
1072	21	37	1:1	1	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 1, "grand_total": 1}	2026-06-19 20:35:51.014474
984	2	34	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 23:01:49.771245
1022	37	34	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 07:15:28.209846
1216	8	41	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-20 23:18:05.149351
1028	18	36	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 07:25:13.324615
1094	27	37	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 01:00:50.086382
1095	27	38	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 01:00:57.524922
1232	22	42	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 07:07:24.677204
1234	22	44	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 07:07:51.713178
924	24	29	3:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 2, "streak_len": 8, "match_total": 1, "grand_total": 3}	2026-06-18 13:01:27.790679
931	25	29	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-18 14:57:19.82935
972	12	29	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-18 20:55:53.542716
991	16	29	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 06:26:23.948708
998	36	29	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-19 06:27:56.927163
1046	33	29	3:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 17:09:50.162162
1049	28	29	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-19 17:25:26.358036
1052	14	29	1:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 17:26:22.822742
1055	32	29	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 18:14:38.430673
1057	31	29	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 18:17:09.819176
1534	32	47	0:3	0	0	\N	2026-06-23 12:43:43.65715
1101	26	36	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 06:54:02.069924
1540	8	50	1:0	0	0	\N	2026-06-23 15:18:14.524679
877	29	31	5:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-18 01:07:24.121244
884	21	31	4:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-18 02:05:19.846548
888	26	31	5:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-18 06:02:13.560294
892	19	31	4:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 2, "streak_len": 7, "match_total": 1, "grand_total": 3}	2026-06-18 06:46:36.760388
905	35	31	5:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-18 08:23:14.530229
912	18	31	5:0	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 3, "streak_len": 10, "match_total": 1, "grand_total": 4}	2026-06-18 09:52:53.858099
920	8	31	5:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-18 11:58:03.44798
922	22	31	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-18 12:22:03.467072
933	25	31	6:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-18 14:57:52.220225
944	27	31	5:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-18 16:35:30.540671
958	4	31	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-18 18:24:29.199411
965	11	31	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-18 18:57:59.331806
981	24	31	3:0	6	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 3, "streak_len": 10, "match_total": 3, "grand_total": 6}	2026-06-18 23:00:03.528302
993	16	31	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-19 06:26:49.250322
1001	36	31	5:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-19 06:38:54.167694
1016	3	31	3:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-19 07:09:26.797023
1019	37	31	6:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-19 07:14:49.819726
1037	30	31	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-19 13:38:48.977205
1051	28	31	3:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 3, "grand_total": 4}	2026-06-19 17:25:46.910675
1053	14	31	4:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-19 17:27:28.513262
1060	12	31	5:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-19 19:29:02.358361
1063	23	31	5:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-19 20:30:03.57628
1066	39	31	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-19 20:33:42.085141
1104	26	39	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 06:54:45.500626
1042	8	34	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 16:39:29.120283
1068	21	34	5:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 20:34:44.951734
1074	1	34	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 21:10:33.864451
1079	9	34	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-19 21:11:27.69096
1091	27	34	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 01:00:22.915654
1099	26	34	4:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 1, "grand_total": 2}	2026-06-20 06:53:24.59494
1107	3	34	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 07:16:57.407358
1132	24	34	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 14:29:53.792106
1137	33	34	2:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-20 15:20:55.666097
1144	14	34	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 15:37:58.54185
1169	38	34	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 16:56:55.524287
1172	28	34	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 16:57:39.545024
1182	32	34	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 17:22:35.952256
1183	10	34	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 18:01:40.260936
1193	11	34	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 19:06:02.543927
1199	31	34	2:1	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	\N
1485	1	45	2:0	0	0	\N	2026-06-23 06:56:53.28007
1200	31	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 22:03:15.149359
1207	23	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 22:17:07.924979
1535	19	50	1:0	0	0	\N	2026-06-23 13:20:52.533275
1536	19	49	2:2	0	0	\N	2026-06-23 13:33:53.527236
1537	19	51	3:0	0	0	\N	2026-06-23 13:34:03.930009
989	19	35	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 05:37:33.203592
997	16	35	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 06:27:49.009432
1008	17	35	4:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 07:01:53.971695
1023	37	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 07:15:39.497436
1027	18	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 07:24:33.164496
1030	29	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 07:55:21.964252
1034	25	35	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 12:01:28.972866
1043	8	35	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 16:39:44.279122
1070	21	35	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 20:35:14.662129
1080	9	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-19 21:11:33.531618
1092	27	35	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 01:00:32.220011
1100	26	35	1:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 06:53:41.524954
1117	12	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 09:21:07.200068
1122	35	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 10:44:50.463079
1126	4	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 12:19:23.308886
1133	24	35	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 14:30:11.199232
1138	33	35	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 15:21:42.669691
1145	14	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 15:38:54.443814
1157	30	35	4:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 16:00:35.469173
1165	36	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 16:23:02.432477
1170	38	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 16:57:06.689864
1174	28	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 16:57:50.522046
1178	1	35	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 16:59:18.082631
1185	10	35	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 18:01:59.982191
1191	39	35	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 19:01:19.61273
1194	11	35	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 19:06:12.746536
1197	32	35	4:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 19:30:07.96358
1202	23	35	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 22:15:13.103047
1210	3	35	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 22:23:45.734494
999	16	36	0:4	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-19 06:28:05.83649
1009	17	36	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 07:02:02.62288
1031	29	36	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 07:55:41.606802
1035	25	36	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 12:01:36.722067
1041	2	36	1:4	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 14:45:01.207728
1241	16	41	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 09:27:53.968276
1238	16	37	3:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-21 09:27:12.754639
1239	16	38	4:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 09:27:34.084413
1240	16	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 09:27:43.123263
1242	16	40	1:3	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-21 09:28:11.342305
1538	25	51	2:0	0	0	\N	2026-06-23 14:49:29.219571
1539	25	52	0:1	0	0	\N	2026-06-23 14:49:36.047176
1544	33	45	2:0	0	0	\N	2026-06-23 16:20:30.27394
1044	8	36	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 16:39:56.648788
1071	21	36	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 20:35:33.477486
1081	9	36	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-19 21:11:40.054934
1093	27	36	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 01:00:41.920564
1108	3	36	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 07:17:05.335388
1123	35	36	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 10:44:59.528458
1127	4	36	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 12:19:30.412746
1134	24	36	0:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 14:30:20.736108
1139	33	36	0:4	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-20 15:21:56.632496
1146	14	36	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 15:39:30.320298
1152	22	36	0:3	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-20 15:56:28.606703
1158	30	36	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 16:00:56.928028
1166	36	36	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 16:26:39.358639
1171	38	36	0:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 16:57:27.717298
1175	28	36	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 16:58:01.961283
1179	1	36	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 16:59:25.024217
1184	10	36	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 18:01:46.915229
1192	39	36	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 19:02:08.272591
1195	11	36	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 19:06:29.48642
1196	12	36	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 19:19:37.609135
1198	32	36	0:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 19:30:18.185704
1201	31	36	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 22:06:35.430568
1203	23	36	0:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 22:15:24.79687
1541	28	46	2:0	0	0	\N	2026-06-23 16:13:22.420264
1542	28	47	0:2	0	0	\N	2026-06-23 16:13:32.264645
1543	28	48	1:0	0	0	\N	2026-06-23 16:13:43.365607
1282	37	45	3:0	0	0	\N	2026-06-21 17:40:08.25427
1244	27	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 10:11:28.871858
1082	9	37	3:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-19 21:11:46.388046
1248	27	44	1:3	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-21 10:12:55.310144
1219	37	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 03:00:49.986851
1253	36	39	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 12:11:39.816631
1254	36	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 12:14:58.283086
1261	24	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 13:29:00.541457
1245	27	41	4:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-21 10:11:54.121803
1246	27	42	5:0	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 1, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 2, "grand_total": 3}	2026-06-21 10:12:00.906881
1247	27	43	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-21 10:12:12.044644
1083	29	37	3:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-19 21:12:47.192881
1102	26	37	4:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-20 06:54:16.664471
1111	17	37	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 09:16:50.167212
1124	35	37	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 10:45:08.077306
1135	24	37	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-20 14:30:30.107225
1140	8	37	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 15:24:51.3636
1147	25	37	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 15:48:15.027853
1159	30	37	4:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-20 16:01:45.939095
1168	36	37	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 16:47:35.220509
1173	38	37	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 16:57:45.248994
1186	10	37	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 18:02:10.039853
1187	39	37	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-20 18:59:32.805026
1204	23	37	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-20 22:16:16.831803
1218	37	37	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 03:00:14.160689
1224	19	37	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 06:45:48.78478
1235	3	37	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 09:06:59.302494
1249	12	37	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-21 10:22:20.636313
1266	32	37	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 13:45:52.050115
1269	31	37	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-21 14:03:55.073857
1270	14	37	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 14:32:59.434547
1271	2	37	5:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 14:33:10.918998
1277	11	37	5:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	\N
1309	25	46	3:1	0	0	\N	2026-06-21 19:39:14.555668
1294	2	44	1:3	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-21 18:12:18.302915
1287	1	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 18:04:22.142729
1296	12	39	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 18:14:20.956754
1290	2	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 18:11:30.195799
1310	11	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "match_total": 0, "streak_bonus": 0, "grand_total": 0}	2026-06-21 20:20:23.474333
1291	2	41	3:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 18:11:38.628455
1300	35	41	4:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 2, "grand_total": 2}	2026-06-21 18:19:38.204487
1306	25	43	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 19:38:50.275921
1292	2	42	5:1	5	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 4, "grand_total": 5}	2026-06-21 18:11:55.139447
1293	2	43	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-21 18:12:05.837505
1307	25	44	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 19:38:58.223257
1295	2	45	3:0	0	0	\N	2026-06-21 18:12:25.572244
1308	25	45	4:0	0	0	\N	2026-06-21 19:39:03.366743
1324	18	45	4:0	0	0	\N	2026-06-21 22:15:43.608766
1320	33	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 21:18:56.126704
1304	25	41	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 19:38:27.758558
1332	16	43	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-21 22:46:06.370876
1325	18	46	3:0	0	0	\N	2026-06-21 22:16:08.811398
1317	22	46	4:0	0	0	\N	2026-06-21 21:07:35.657185
1326	18	47	1:3	0	0	\N	2026-06-21 22:16:20.067925
1314	39	40	1:3	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-21 20:36:41.222673
1315	39	41	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-21 20:36:54.258571
1305	25	42	5:0	5	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 4, "grand_total": 5}	2026-06-21 19:38:35.107433
1321	31	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 21:26:30.381567
1312	11	40	0:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 20:20:58.077874
1322	31	40	1:3	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-21 21:26:57.32229
1323	3	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 21:40:13.830084
1089	18	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 00:09:36.565935
1103	26	38	0:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-20 06:54:29.185224
1112	17	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 09:17:06.073998
1141	8	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 15:26:08.290627
1148	25	38	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 15:48:28.759786
1154	22	38	1:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-20 15:56:50.029144
1160	30	38	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 16:02:09.446896
1176	38	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 16:58:03.337064
1181	1	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 16:59:40.053043
1188	39	38	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 18:59:46.134434
1205	23	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 22:16:36.711843
1217	37	38	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 02:58:19.997223
1225	19	38	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 06:45:59.147892
1236	3	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 09:07:08.435246
1252	36	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 12:08:48.088873
1259	24	38	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 13:28:24.781071
1267	32	38	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 13:45:59.955388
1272	14	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 14:34:30.170091
1274	2	38	1:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-21 14:35:17.176202
1276	11	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 15:52:58.893463
1278	12	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 16:04:13.527632
1279	28	38	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 16:15:11.223519
1284	33	38	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 17:44:54.999232
1285	4	38	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 17:55:21.912387
1297	35	38	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 18:18:43.267549
1302	31	38	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 18:40:21.265465
1316	22	45	3:1	0	0	\N	2026-06-21 21:07:01.439766
1318	2	46	3:1	0	0	\N	2026-06-21 21:07:37.608458
1338	10	45	3:0	0	0	\N	2026-06-22 02:47:30.189029
1339	10	46	4:1	0	0	\N	2026-06-22 02:47:47.648551
1340	10	47	1:3	0	0	\N	2026-06-22 02:48:01.558843
1341	10	48	2:2	0	0	\N	2026-06-22 02:48:14.347849
1346	26	45	2:0	0	0	\N	2026-06-22 05:25:05.901536
1347	26	46	2:1	0	0	\N	2026-06-22 05:25:21.39575
1348	26	47	0:2	0	0	\N	2026-06-22 05:25:31.976894
1349	26	48	3:0	0	0	\N	2026-06-22 05:26:25.573844
1350	29	45	4:0	0	0	\N	2026-06-22 05:50:29.228224
1351	29	46	3:0	0	0	\N	2026-06-22 05:50:35.638344
1352	29	47	0:2	0	0	\N	2026-06-22 05:50:48.614179
1353	29	48	2:1	0	0	\N	2026-06-22 05:50:57.261088
1096	27	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 01:01:17.815666
1330	38	43	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 22:19:46.009422
1369	17	47	1:3	0	0	\N	2026-06-22 08:04:05.117011
1372	16	45	3:1	0	0	\N	2026-06-22 08:04:25.437754
1329	38	42	4:0	5	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 4, "grand_total": 5}	2026-06-21 22:19:32.086603
1331	38	44	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 22:19:58.985284
1113	17	39	1:1	2	0	{"base": 1, "high_score": 0, "underdog": 1, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 2, "grand_total": 2}	2026-06-20 09:17:25.486733
1149	25	39	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 15:48:42.122966
1155	22	39	3:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 15:58:00.534233
1161	30	39	4:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 16:02:25.618852
1189	39	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 19:00:09.207703
1206	23	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 22:16:57.931041
1226	19	39	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 06:46:18.402247
1237	3	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 09:07:15.307347
1260	24	39	1:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 13:28:41.556066
1268	32	39	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 13:46:12.101414
1273	14	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 14:35:03.601998
1280	28	39	2:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 16:15:22.627164
1286	4	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 17:55:28.511276
1289	2	39	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 18:11:21.188374
1298	35	39	2:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 18:19:02.371615
1319	33	39	3:0	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 21:18:17.828564
1376	36	46	3:0	0	0	\N	2026-06-22 10:06:51.216056
1363	17	41	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-22 08:03:09.028385
1360	1	42	4:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-22 07:54:59.068392
1357	8	43	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-22 07:54:39.640735
1365	17	43	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-22 08:03:31.489098
1371	16	44	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-22 08:04:15.59209
1105	26	40	2:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 06:55:05.09569
1114	17	40	1:3	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-20 09:17:36.230028
1119	29	40	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-20 09:46:29.128043
1150	25	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 15:48:48.744235
1156	22	40	3:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-20 15:58:35.532687
1162	30	40	1:3	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-20 16:03:07.955574
1215	8	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 23:17:51.520707
1220	37	40	1:3	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-21 03:01:14.786302
1227	19	40	1:3	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-21 06:46:31.915227
1275	14	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 14:35:57.005707
1281	28	40	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 16:15:35.877301
1288	1	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 18:04:34.967147
1299	35	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 18:19:21.458057
1303	12	40	0:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 19:17:41.353327
1327	38	40	1:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 22:18:54.383686
1333	32	40	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-22 00:35:53.901386
1367	17	45	3:0	0	0	\N	2026-06-22 08:03:51.102722
1370	17	48	2:0	0	0	\N	2026-06-22 08:04:13.534567
1373	16	46	3:0	0	0	\N	2026-06-22 08:04:34.38008
1374	18	48	1:1	0	0	\N	2026-06-22 09:06:31.518094
1377	12	41	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-22 11:26:33.033039
1368	17	46	3:1	0	0	\N	2026-06-22 08:03:58.032527
1364	17	42	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-22 08:03:18.50581
1361	1	43	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-22 07:55:21.825925
1358	8	44	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-22 07:54:51.090653
1362	1	44	0:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-22 07:55:37.809221
1366	17	44	1:2	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 6, "match_total": 3, "grand_total": 4}	2026-06-22 08:03:42.699757
1375	36	45	2:0	0	0	\N	2026-06-22 09:40:29.453624
1380	19	45	2:0	0	0	\N	2026-06-22 13:16:18.091466
1381	19	46	3:1	0	0	\N	2026-06-22 13:16:29.004896
1382	19	47	0:3	0	0	\N	2026-06-22 13:16:38.16091
1395	4	41	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-22 14:14:12.770903
1388	14	45	2:0	0	0	\N	2026-06-22 13:38:11.218774
1389	14	46	3:1	0	0	\N	2026-06-22 13:38:30.324455
1390	14	47	0:2	0	0	\N	2026-06-22 13:39:09.387773
1391	14	48	2:0	0	0	\N	2026-06-22 13:39:30.618416
1394	32	43	4:1	5	0	{"base": 1, "high_score": 1, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 4, "grand_total": 5}	2026-06-22 13:43:41.057742
1440	21	47	1:2	0	0	\N	2026-06-22 17:34:54.563236
1417	8	47	1:2	0	0	\N	2026-06-22 14:57:37.415349
1399	4	45	4:0	0	0	\N	2026-06-22 14:14:38.308373
1400	4	46	2:0	0	0	\N	2026-06-22 14:14:44.572028
1401	4	48	2:1	0	0	\N	2026-06-22 14:14:51.967711
1402	4	47	0:2	0	0	\N	2026-06-22 14:15:00.981997
1403	24	45	3:0	0	0	\N	2026-06-22 14:38:11.517975
1404	24	46	2:0	0	0	\N	2026-06-22 14:38:22.741839
1383	19	48	3:1	0	0	\N	2026-06-22 13:16:51.473866
1405	22	47	1:3	0	0	\N	2026-06-22 14:46:24.473784
1406	22	48	0:0	0	0	\N	2026-06-22 14:46:38.157284
1415	8	45	3:1	0	0	\N	2026-06-22 14:55:00.393741
1416	8	46	4:0	0	0	\N	2026-06-22 14:56:37.183775
1411	30	45	5:0	0	0	\N	2026-06-22 14:53:42.377047
1412	30	46	5:1	0	0	\N	2026-06-22 14:54:13.208176
1413	30	47	1:3	0	0	\N	2026-06-22 14:54:25.048215
1414	30	48	2:0	0	0	\N	2026-06-22 14:54:40.322953
1418	8	48	3:1	0	0	\N	2026-06-22 14:59:20.928356
1420	37	46	4:0	0	0	\N	2026-06-22 15:23:00.829464
1386	14	43	1:2	-1	0	{"base": -1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": -1, "grand_total": -1}	2026-06-22 13:35:49.688508
1434	26	49	1:3	0	0	\N	2026-06-22 17:32:37.258194
1438	21	45	5:1	0	0	\N	2026-06-22 17:34:24.487526
1439	21	46	2:1	0	0	\N	2026-06-22 17:34:36.969998
1441	21	48	1:1	0	0	\N	2026-06-22 17:35:06.484113
1442	21	49	2:2	0	0	\N	2026-06-22 17:35:15.123666
1208	23	41	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-20 22:17:19.168072
1213	29	41	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-20 23:02:05.465923
1221	37	41	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-21 03:01:37.709274
1228	19	41	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 06:48:00.704279
1231	22	41	3:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 07:07:12.266421
1255	36	41	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 12:16:35.213653
1262	24	41	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 13:29:09.575828
1313	11	41	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 20:21:47.166007
1328	38	41	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-21 22:19:09.781346
1334	10	41	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-22 02:46:34.9008
1342	26	41	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-22 05:24:08.441994
1359	1	41	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-22 07:54:52.435409
1384	14	41	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-22 13:32:07.048431
1392	32	41	4:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-22 13:43:06.984389
1407	30	41	4:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-22 14:51:09.830917
1419	31	41	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-22 15:14:02.615277
1421	3	41	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-22 15:30:40.325238
1378	12	42	5:0	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-22 11:26:45.558844
1385	14	42	4:0	5	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 4, "grand_total": 5}	2026-06-22 13:32:38.830109
1379	19	44	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-22 13:16:05.277703
1387	14	44	1:2	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-22 13:36:42.407078
1425	28	41	2:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-22 16:00:51.013467
1429	33	41	3:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-22 16:08:50.710617
1458	27	48	1:1	0	0	\N	2026-06-22 20:14:03.703229
1450	9	45	3:0	0	0	\N	2026-06-22 19:55:44.437123
1451	9	46	2:0	0	0	\N	2026-06-22 19:55:56.893938
1452	9	47	0:2	0	0	\N	2026-06-22 19:56:06.055896
1453	9	48	1:0	0	0	\N	2026-06-22 19:56:16.242286
1454	9	49	1:1	0	0	\N	2026-06-22 19:56:23.938703
1455	27	45	4:1	0	0	\N	2026-06-22 20:13:24.900955
1456	27	46	3:1	0	0	\N	2026-06-22 20:13:33.826044
1457	27	47	0:2	0	0	\N	2026-06-22 20:13:47.212249
1459	27	49	1:3	0	0	\N	2026-06-22 20:16:59.642199
1460	25	50	1:0	0	0	\N	2026-06-22 20:58:07.223657
1461	25	49	1:1	0	0	\N	2026-06-22 20:58:16.09587
1462	25	48	2:0	0	0	\N	2026-06-22 20:58:22.842118
1463	25	47	0:2	0	0	\N	2026-06-22 20:58:30.197563
1470	27	50	2:0	0	0	\N	2026-06-23 00:00:02.689795
1471	27	51	4:1	0	0	\N	2026-06-23 00:00:12.412887
1472	26	50	1:0	0	0	\N	2026-06-23 04:39:40.684422
1473	26	52	0:3	0	0	\N	2026-06-23 04:39:52.939124
1474	26	51	4:0	0	0	\N	2026-06-23 04:40:01.964772
1209	23	42	3:0	6	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 5, "grand_total": 6}	2026-06-20 22:17:29.456392
1222	37	42	6:0	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 2, "grand_total": 3}	2026-06-21 03:02:01.492841
1229	19	42	5:0	5	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 4, "grand_total": 5}	2026-06-21 06:48:23.990987
1243	16	42	4:0	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-21 09:28:26.253926
1256	36	42	5:0	5	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 4, "grand_total": 5}	2026-06-21 12:25:42.4681
1263	24	42	2:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-21 13:29:19.979232
1301	35	42	5:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-21 18:20:09.484367
1335	10	42	5:0	4	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 4, "grand_total": 4}	2026-06-22 02:46:50.72078
1343	26	42	4:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-22 05:24:19.17829
1356	8	42	6:0	5	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 4, "grand_total": 5}	2026-06-22 07:54:27.270749
1393	32	42	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-22 13:43:16.421
1396	4	42	3:0	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 3, "grand_total": 3}	2026-06-22 14:14:18.502011
1408	30	42	6:0	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 2, "grand_total": 3}	2026-06-22 14:51:23.366934
1422	3	42	3:0	4	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 3, "grand_total": 4}	2026-06-22 15:30:45.940918
1426	28	42	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-22 16:01:00.88005
1430	33	42	4:0	5	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 4, "grand_total": 5}	2026-06-22 16:09:13.075621
1431	39	42	4:0	5	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 1, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 4, "grand_total": 5}	2026-06-22 16:57:44.682306
1435	21	42	5:1	3	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-22 17:33:41.824754
1443	31	42	5:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-22 18:45:47.912889
1444	11	42	4:0	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-22 19:20:47.895092
1447	9	42	4:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-22 19:55:19.894217
1223	37	43	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 03:02:14.387021
1230	19	43	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 06:48:41.168333
1233	22	43	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-21 07:07:34.946068
1250	18	43	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 10:53:48.599533
1445	11	43	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-22 19:21:29.245488
1446	11	44	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-22 19:22:03.429751
1257	29	43	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-21 12:41:28.001629
1264	24	43	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-21 13:29:31.973668
1336	10	43	3:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-22 02:47:01.80759
1354	36	43	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-22 06:52:05.654911
1397	4	43	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-22 14:14:24.739444
1423	3	43	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-22 15:30:51.187977
1432	39	43	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-22 16:59:24.893361
1436	21	43	2:0	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-22 17:33:58.448749
1448	9	43	2:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 2, "match_total": 1, "grand_total": 1}	2026-06-22 19:55:26.47544
1464	12	43	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-22 21:05:29.279073
1466	23	43	2:2	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-22 22:14:39.571764
1469	33	43	2:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-22 23:03:58.819217
1251	18	44	0:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 10:54:08.328341
1258	29	44	1:3	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-21 12:41:50.058539
1265	24	44	0:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-21 13:29:44.511803
1283	37	44	1:2	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-21 17:44:11.808657
1337	10	44	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-22 02:47:16.504686
1345	26	44	1:2	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-22 05:24:49.017865
1355	36	44	0:1	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-22 06:53:04.093039
1398	4	44	1:2	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-22 14:14:31.809386
1410	30	44	1:4	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-22 14:53:28.61332
1424	3	44	0:2	1	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 1, "grand_total": 1}	2026-06-22 15:30:58.415206
1428	28	44	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 1, "grand_total": 2}	2026-06-22 16:01:17.156555
1433	39	44	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-22 17:00:46.403774
1437	21	44	1:4	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 1, "grand_total": 2}	2026-06-22 17:34:09.449699
1449	9	44	1:1	0	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 0, "grand_total": 0}	2026-06-22 19:55:35.995005
1465	12	44	0:2	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-22 21:05:42.513031
1467	23	44	1:2	3	0	{"base": 3, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 0, "streak_len": 1, "match_total": 3, "grand_total": 3}	2026-06-22 22:14:52.035754
1468	33	44	0:1	2	0	{"base": 1, "high_score": 0, "underdog": 0, "favorite": 0, "star": 0, "multiplier": 1, "streak_bonus": 1, "streak_len": 5, "match_total": 1, "grand_total": 2}	2026-06-22 23:03:09.127063
1344	26	43	2:2	2	0	{"base": 0, "high_score": 0, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 0, "streak_len": 0, "match_total": 2, "grand_total": 2}	2026-06-22 05:24:31.508271
1409	30	43	3:2	7	0	{"base": 3, "high_score": 1, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 4, "match_total": 6, "grand_total": 7}	2026-06-22 14:53:07.804946
1427	28	43	3:2	7	0	{"base": 3, "high_score": 1, "underdog": 0, "favorite": 0, "star": 2, "multiplier": 1, "streak_bonus": 1, "streak_len": 3, "match_total": 6, "grand_total": 7}	2026-06-22 16:01:09.664938
\.


--
-- Name: matches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

SELECT pg_catalog.setval('public.matches_id_seq', 72, true);


--
-- Name: players_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

SELECT pg_catalog.setval('public.players_id_seq', 39, true);


--
-- Name: user_picks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

SELECT pg_catalog.setval('public.user_picks_id_seq', 1544, true);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: user_picks user_picks_pkey; Type: CONSTRAINT; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

ALTER TABLE ONLY public.user_picks
    ADD CONSTRAINT user_picks_pkey PRIMARY KEY (id);


--
-- Name: ix_matches_id; Type: INDEX; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE INDEX ix_matches_id ON public.matches USING btree (id);


--
-- Name: ix_players_email; Type: INDEX; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE UNIQUE INDEX ix_players_email ON public.players USING btree (email);


--
-- Name: ix_players_id; Type: INDEX; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE INDEX ix_players_id ON public.players USING btree (id);


--
-- Name: ix_players_username; Type: INDEX; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE UNIQUE INDEX ix_players_username ON public.players USING btree (username);


--
-- Name: ix_user_picks_id; Type: INDEX; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE INDEX ix_user_picks_id ON public.user_picks USING btree (id);


--
-- Name: uq_user_picks_player_match; Type: INDEX; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

CREATE UNIQUE INDEX uq_user_picks_player_match ON public.user_picks USING btree (player_id, match_id);


--
-- Name: user_picks user_picks_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

ALTER TABLE ONLY public.user_picks
    ADD CONSTRAINT user_picks_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(id);


--
-- Name: user_picks user_picks_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bet_world_cup_2026_db_live_user
--

ALTER TABLE ONLY public.user_picks
    ADD CONSTRAINT user_picks_player_id_fkey FOREIGN KEY (player_id) REFERENCES public.players(id);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO bet_world_cup_2026_db_live_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO bet_world_cup_2026_db_live_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO bet_world_cup_2026_db_live_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO bet_world_cup_2026_db_live_user;


--
-- PostgreSQL database dump complete
--

\unrestrict clu0m3TjNfKnaySEYL0Ryn0pU6dld8SQiZrnHdzKzj8Wz5pQyHT2Ep1iyi0gHac

