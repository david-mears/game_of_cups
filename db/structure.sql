SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: game_statuses; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.game_statuses AS ENUM (
    'draft',
    'started',
    'finished',
    'trashed'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: cups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cups (
    id bigint NOT NULL,
    kind integer,
    image character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    game_id bigint,
    label character varying
);


--
-- Name: cups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cups_id_seq OWNED BY public.cups.id;


--
-- Name: draughts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.draughts (
    player_id bigint NOT NULL,
    cup_id bigint NOT NULL,
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: draughts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.draughts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: draughts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.draughts_id_seq OWNED BY public.draughts.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.games (
    id bigint NOT NULL,
    slug character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    number_of_players integer,
    status public.game_statuses,
    number_of_evil_players_at_start integer
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.games_id_seq OWNED BY public.games.id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.players (
    id bigint NOT NULL,
    name character varying,
    allegiance integer DEFAULT 1,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    game_id bigint,
    arthur boolean DEFAULT false
);


--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.players_id_seq OWNED BY public.players.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: cups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cups ALTER COLUMN id SET DEFAULT nextval('public.cups_id_seq'::regclass);


--
-- Name: draughts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draughts ALTER COLUMN id SET DEFAULT nextval('public.draughts_id_seq'::regclass);


--
-- Name: games id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games ALTER COLUMN id SET DEFAULT nextval('public.games_id_seq'::regclass);


--
-- Name: players id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players ALTER COLUMN id SET DEFAULT nextval('public.players_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: cups cups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cups
    ADD CONSTRAINT cups_pkey PRIMARY KEY (id);


--
-- Name: draughts draughts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draughts
    ADD CONSTRAINT draughts_pkey PRIMARY KEY (id);


--
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_cups_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cups_on_game_id ON public.cups USING btree (game_id);


--
-- Name: index_games_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_games_on_slug ON public.games USING btree (slug);


--
-- Name: index_players_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_players_on_game_id ON public.players USING btree (game_id);


--
-- Name: cups fk_rails_9217cbbd43; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cups
    ADD CONSTRAINT fk_rails_9217cbbd43 FOREIGN KEY (game_id) REFERENCES public.games(id);


--
-- Name: players fk_rails_d71756309d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT fk_rails_d71756309d FOREIGN KEY (game_id) REFERENCES public.games(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200816002231'),
('20200816010221'),
('20200816011452'),
('20200816012122'),
('20200816012145'),
('20200816013524'),
('20200831225041'),
('20200831233526'),
('20200911155424'),
('20200913163000'),
('20200913163114'),
('20200917233347'),
('20200918002838'),
('20200918160949'),
('20200918174248'),
('20200918194534'),
('20200919160443'),
('20200925170533'),
('20201127212903');


