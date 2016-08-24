--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: actions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE actions (
    id integer NOT NULL,
    longitude numeric(9,6) DEFAULT 0,
    latitude numeric(9,6) DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    actionable_type character varying,
    actionable_id integer,
    user_id integer,
    distance integer DEFAULT 0
);


--
-- Name: actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE actions_id_seq OWNED BY actions.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE activities (
    id integer NOT NULL,
    title character varying,
    place character varying,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    content text DEFAULT ''::text,
    longitude numeric(9,6) DEFAULT 0,
    latitude numeric(9,6) DEFAULT 0,
    distance integer DEFAULT 0,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    price numeric(10,2) DEFAULT 0
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: app_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE app_versions (
    id integer NOT NULL,
    version character varying NOT NULL,
    changelog character varying DEFAULT ''::character varying,
    name character varying,
    app character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: app_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE app_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE app_versions_id_seq OWNED BY app_versions.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE articles (
    id integer NOT NULL,
    title character varying,
    title_image_url character varying,
    body character varying,
    published boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE articles_id_seq OWNED BY articles.id;


--
-- Name: bikes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bikes (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying,
    module_id character varying NOT NULL,
    longitude numeric(9,6) DEFAULT 0.0,
    latitude numeric(9,6) DEFAULT 0.0,
    battery numeric(6,2) DEFAULT 0.0,
    travel_mileage numeric(10,2) DEFAULT 0.0,
    diag_info hstore DEFAULT ''::hstore,
    user_id integer,
    iccid character varying
);


--
-- Name: bikes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bikes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bikes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bikes_id_seq OWNED BY bikes.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events (
    id integer NOT NULL,
    title character varying,
    content text DEFAULT ''::text,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    longitude numeric(9,6) DEFAULT 0,
    latitude numeric(9,6) DEFAULT 0,
    distance integer DEFAULT 0,
    event_type integer DEFAULT 0,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    place character varying,
    actionable_type character varying,
    actionable_id integer
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: friendships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE friendships (
    id integer NOT NULL,
    requested_at timestamp without time zone,
    accepted_at timestamp without time zone,
    status character varying,
    friend_id integer,
    user_id integer
);


--
-- Name: friendships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendships_id_seq OWNED BY friendships.id;


--
-- Name: image_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE image_attachments (
    id integer NOT NULL,
    file character varying,
    imageable_type character varying,
    imageable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: image_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE image_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: image_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE image_attachments_id_seq OWNED BY image_attachments.id;


--
-- Name: livings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE livings (
    id integer NOT NULL,
    title character varying,
    place character varying,
    content text DEFAULT ''::text,
    longitude numeric(9,6) DEFAULT 0,
    latitude numeric(9,6) DEFAULT 0,
    distance integer DEFAULT 0,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    price numeric(10,2) DEFAULT 0
);


--
-- Name: livings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE livings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: livings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE livings_id_seq OWNED BY livings.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE locations (
    id integer NOT NULL,
    longitude numeric(9,6) DEFAULT 0.0,
    latitude numeric(9,6) DEFAULT 0.0,
    bike_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media (
    id integer NOT NULL,
    type integer,
    media character varying,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_id_seq OWNED BY media.id;


--
-- Name: oauth_access_grants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE oauth_access_grants (
    id integer NOT NULL,
    resource_owner_id integer NOT NULL,
    application_id integer NOT NULL,
    token character varying NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying
);


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oauth_access_grants_id_seq OWNED BY oauth_access_grants.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE oauth_access_tokens (
    id integer NOT NULL,
    resource_owner_id integer,
    application_id integer NOT NULL,
    token character varying NOT NULL,
    refresh_token character varying,
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying
);


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oauth_access_tokens_id_seq OWNED BY oauth_access_tokens.id;


--
-- Name: oauth_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE oauth_applications (
    id integer NOT NULL,
    name character varying NOT NULL,
    uid character varying NOT NULL,
    secret character varying NOT NULL,
    redirect_uri text NOT NULL,
    scopes character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    owner_id integer,
    owner_type character varying,
    mongo_id character varying
);


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oauth_applications_id_seq OWNED BY oauth_applications.id;


--
-- Name: order_takes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE order_takes (
    id integer NOT NULL,
    take_along_something_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: order_takes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE order_takes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_takes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE order_takes_id_seq OWNED BY order_takes.id;


--
-- Name: participations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE participations (
    id integer NOT NULL,
    activity_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: participations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE participations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE participations_id_seq OWNED BY participations.id;


--
-- Name: passing_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE passing_locations (
    id integer NOT NULL,
    longitude numeric(9,6) NOT NULL,
    latitude numeric(9,6) NOT NULL,
    travel_plan_id integer
);


--
-- Name: passing_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE passing_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: passing_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE passing_locations_id_seq OWNED BY passing_locations.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE posts (
    id integer NOT NULL,
    text text,
    user_id integer,
    topic_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: receivers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE receivers (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying,
    phone character varying DEFAULT ''::character varying,
    address character varying DEFAULT ''::character varying,
    take_along_something_id integer,
    longitude numeric(9,6) DEFAULT 0,
    latitude numeric(9,6) DEFAULT 0,
    place character varying DEFAULT ''::character varying
);


--
-- Name: receivers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE receivers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receivers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE receivers_id_seq OWNED BY receivers.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: senders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE senders (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying,
    phone character varying DEFAULT ''::character varying,
    address character varying DEFAULT ''::character varying,
    take_along_something_id integer,
    longitude numeric(9,6) DEFAULT 0,
    latitude numeric(9,6) DEFAULT 0,
    place character varying DEFAULT ''::character varying
);


--
-- Name: senders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE senders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: senders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE senders_id_seq OWNED BY senders.id;


--
-- Name: sms_validation_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sms_validation_codes (
    id integer NOT NULL,
    validation_code character varying,
    phone character varying,
    expires_in integer,
    type integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sms_validation_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sms_validation_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sms_validation_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sms_validation_codes_id_seq OWNED BY sms_validation_codes.id;


--
-- Name: take_along_somethings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE take_along_somethings (
    id integer NOT NULL,
    title character varying,
    place character varying,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    content text DEFAULT ''::text,
    price numeric(10,2) DEFAULT 0,
    longitude numeric(9,6) DEFAULT 0,
    latitude numeric(9,6) DEFAULT 0,
    distance integer DEFAULT 0,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: take_along_somethings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE take_along_somethings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: take_along_somethings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE take_along_somethings_id_seq OWNED BY take_along_somethings.id;


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE topics (
    id integer NOT NULL,
    subject character varying,
    text text,
    views_count integer DEFAULT 1,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topics_id_seq OWNED BY topics.id;


--
-- Name: travel_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE travel_plans (
    id integer NOT NULL,
    content character varying DEFAULT ''::character varying,
    start_off_time timestamp without time zone,
    dest_loc_longitude numeric(9,6) NOT NULL,
    dest_loc_latitude numeric(9,6) NOT NULL,
    status integer DEFAULT 0,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: travel_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE travel_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: travel_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE travel_plans_id_seq OWNED BY travel_plans.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    name character varying DEFAULT ''::character varying NOT NULL,
    points integer DEFAULT 0 NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    phone character varying DEFAULT ''::character varying NOT NULL,
    oauth_login_code character varying DEFAULT ''::character varying NOT NULL,
    online boolean DEFAULT false NOT NULL,
    avatar character varying,
    longitude numeric(9,6) DEFAULT 0 NOT NULL,
    latitude numeric(9,6) DEFAULT 0 NOT NULL,
    mongo_id character varying,
    title character varying,
    level character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: video_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE video_attachments (
    id integer NOT NULL,
    file character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    living_id integer
);


--
-- Name: video_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE video_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: video_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE video_attachments_id_seq OWNED BY video_attachments.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY actions ALTER COLUMN id SET DEFAULT nextval('actions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY app_versions ALTER COLUMN id SET DEFAULT nextval('app_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles ALTER COLUMN id SET DEFAULT nextval('articles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bikes ALTER COLUMN id SET DEFAULT nextval('bikes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendships ALTER COLUMN id SET DEFAULT nextval('friendships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY image_attachments ALTER COLUMN id SET DEFAULT nextval('image_attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY livings ALTER COLUMN id SET DEFAULT nextval('livings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media ALTER COLUMN id SET DEFAULT nextval('media_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('oauth_access_grants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('oauth_access_tokens_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_applications ALTER COLUMN id SET DEFAULT nextval('oauth_applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_takes ALTER COLUMN id SET DEFAULT nextval('order_takes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY participations ALTER COLUMN id SET DEFAULT nextval('participations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY passing_locations ALTER COLUMN id SET DEFAULT nextval('passing_locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY receivers ALTER COLUMN id SET DEFAULT nextval('receivers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY senders ALTER COLUMN id SET DEFAULT nextval('senders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sms_validation_codes ALTER COLUMN id SET DEFAULT nextval('sms_validation_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY take_along_somethings ALTER COLUMN id SET DEFAULT nextval('take_along_somethings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY travel_plans ALTER COLUMN id SET DEFAULT nextval('travel_plans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY video_attachments ALTER COLUMN id SET DEFAULT nextval('video_attachments_id_seq'::regclass);


--
-- Name: actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY actions
    ADD CONSTRAINT actions_pkey PRIMARY KEY (id);


--
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: app_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY app_versions
    ADD CONSTRAINT app_versions_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: bikes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bikes
    ADD CONSTRAINT bikes_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: friendships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendships
    ADD CONSTRAINT friendships_pkey PRIMARY KEY (id);


--
-- Name: image_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY image_attachments
    ADD CONSTRAINT image_attachments_pkey PRIMARY KEY (id);


--
-- Name: livings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY livings
    ADD CONSTRAINT livings_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);


--
-- Name: order_takes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_takes
    ADD CONSTRAINT order_takes_pkey PRIMARY KEY (id);


--
-- Name: participations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY participations
    ADD CONSTRAINT participations_pkey PRIMARY KEY (id);


--
-- Name: passing_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY passing_locations
    ADD CONSTRAINT passing_locations_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: receivers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY receivers
    ADD CONSTRAINT receivers_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: senders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY senders
    ADD CONSTRAINT senders_pkey PRIMARY KEY (id);


--
-- Name: sms_validation_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sms_validation_codes
    ADD CONSTRAINT sms_validation_codes_pkey PRIMARY KEY (id);


--
-- Name: take_along_somethings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY take_along_somethings
    ADD CONSTRAINT take_along_somethings_pkey PRIMARY KEY (id);


--
-- Name: topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: travel_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY travel_plans
    ADD CONSTRAINT travel_plans_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: video_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY video_attachments
    ADD CONSTRAINT video_attachments_pkey PRIMARY KEY (id);


--
-- Name: index_actions_on_actionable_type_and_actionable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_actions_on_actionable_type_and_actionable_id ON actions USING btree (actionable_type, actionable_id);


--
-- Name: index_actions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_actions_on_user_id ON actions USING btree (user_id);


--
-- Name: index_activities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_user_id ON activities USING btree (user_id);


--
-- Name: index_bikes_on_diag_info; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_diag_info ON bikes USING gin (diag_info);


--
-- Name: index_bikes_on_module_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bikes_on_module_id ON bikes USING btree (module_id);


--
-- Name: index_bikes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_user_id ON bikes USING btree (user_id);


--
-- Name: index_events_on_actionable_type_and_actionable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_actionable_type_and_actionable_id ON events USING btree (actionable_type, actionable_id);


--
-- Name: index_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_user_id ON events USING btree (user_id);


--
-- Name: index_friendships_on_friend_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendships_on_friend_id ON friendships USING btree (friend_id);


--
-- Name: index_friendships_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendships_on_status ON friendships USING btree (status);


--
-- Name: index_friendships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendships_on_user_id ON friendships USING btree (user_id);


--
-- Name: index_image_attachments_on_imageable_type_and_imageable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_image_attachments_on_imageable_type_and_imageable_id ON image_attachments USING btree (imageable_type, imageable_id);


--
-- Name: index_livings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_livings_on_user_id ON livings USING btree (user_id);


--
-- Name: index_locations_on_bike_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_bike_id ON locations USING btree (bike_id);


--
-- Name: index_media_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_media_on_user_id ON media USING btree (user_id);


--
-- Name: index_oauth_access_grants_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_grants_on_application_id ON oauth_access_grants USING btree (application_id);


--
-- Name: index_oauth_access_grants_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON oauth_access_grants USING btree (token);


--
-- Name: index_oauth_access_tokens_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_tokens_on_application_id ON oauth_access_tokens USING btree (application_id);


--
-- Name: index_oauth_access_tokens_on_refresh_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON oauth_access_tokens USING btree (refresh_token);


--
-- Name: index_oauth_access_tokens_on_resource_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON oauth_access_tokens USING btree (resource_owner_id);


--
-- Name: index_oauth_access_tokens_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON oauth_access_tokens USING btree (token);


--
-- Name: index_oauth_applications_on_owner_id_and_owner_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_applications_on_owner_id_and_owner_type ON oauth_applications USING btree (owner_id, owner_type);


--
-- Name: index_oauth_applications_on_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_applications_on_uid ON oauth_applications USING btree (uid);


--
-- Name: index_on_actions_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_actions_location ON actions USING gist (st_geographyfromtext((((('SRID=4326;POINT('::text || longitude) || ' '::text) || latitude) || ')'::text)));


--
-- Name: index_on_activities_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_activities_location ON activities USING gist (st_geographyfromtext((((('SRID=4326;POINT('::text || longitude) || ' '::text) || latitude) || ')'::text)));


--
-- Name: index_on_livings_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_livings_location ON livings USING gist (st_geographyfromtext((((('SRID=4326;POINT('::text || longitude) || ' '::text) || latitude) || ')'::text)));


--
-- Name: index_on_take_along_somethings_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_take_along_somethings_location ON take_along_somethings USING gist (st_geographyfromtext((((('SRID=4326;POINT('::text || longitude) || ' '::text) || latitude) || ')'::text)));


--
-- Name: index_order_takes_on_take_along_something_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_takes_on_take_along_something_id ON order_takes USING btree (take_along_something_id);


--
-- Name: index_order_takes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_takes_on_user_id ON order_takes USING btree (user_id);


--
-- Name: index_participations_on_activity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participations_on_activity_id ON participations USING btree (activity_id);


--
-- Name: index_participations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participations_on_user_id ON participations USING btree (user_id);


--
-- Name: index_passing_locations_on_travel_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_passing_locations_on_travel_plan_id ON passing_locations USING btree (travel_plan_id);


--
-- Name: index_posts_on_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_topic_id ON posts USING btree (topic_id);


--
-- Name: index_posts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_user_id ON posts USING btree (user_id);


--
-- Name: index_receivers_on_take_along_something_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_receivers_on_take_along_something_id ON receivers USING btree (take_along_something_id);


--
-- Name: index_senders_on_take_along_something_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_senders_on_take_along_something_id ON senders USING btree (take_along_something_id);


--
-- Name: index_take_along_somethings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_take_along_somethings_on_user_id ON take_along_somethings USING btree (user_id);


--
-- Name: index_topics_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_topics_on_user_id ON topics USING btree (user_id);


--
-- Name: index_travel_plans_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_travel_plans_on_user_id ON travel_plans USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_name ON users USING btree (name);


--
-- Name: index_users_on_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_phone ON users USING btree (phone);


--
-- Name: index_video_attachments_on_living_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_video_attachments_on_living_id ON video_attachments USING btree (living_id);


--
-- Name: fk_rails_45f6b6dc45; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_takes
    ADD CONSTRAINT fk_rails_45f6b6dc45 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_7309fb7a55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY order_takes
    ADD CONSTRAINT fk_rails_7309fb7a55 FOREIGN KEY (take_along_something_id) REFERENCES take_along_somethings(id);


--
-- Name: fk_rails_732cb83ab7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_rails_732cb83ab7 FOREIGN KEY (application_id) REFERENCES oauth_applications(id);


--
-- Name: fk_rails_7497d0a785; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY video_attachments
    ADD CONSTRAINT fk_rails_7497d0a785 FOREIGN KEY (living_id) REFERENCES livings(id);


--
-- Name: fk_rails_92013479b0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY participations
    ADD CONSTRAINT fk_rails_92013479b0 FOREIGN KEY (activity_id) REFERENCES activities(id);


--
-- Name: fk_rails_b4b53e07b8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_rails_b4b53e07b8 FOREIGN KEY (application_id) REFERENCES oauth_applications(id);


--
-- Name: fk_rails_e80f5ca3a2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY participations
    ADD CONSTRAINT fk_rails_e80f5ca3a2 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160523091904'), ('20160525071248'), ('20160525082438'), ('20160606035233'), ('20160613062612'), ('20160614015218'), ('20160726080254'), ('20160808024844'), ('20160808055827'), ('20160808072134'), ('20160822060130'), ('20160822060641'), ('20160822060908'), ('20160822063724'), ('20160822063741'), ('20160822072047'), ('20160822072115'), ('20160822072620'), ('20160822074629'), ('20160822074719'), ('20160822074903'), ('20160822075347'), ('20160822075429'), ('20160822081855'), ('20160823074345'), ('20160823074410'), ('20160823074419'), ('20160823075554'), ('20160823083109'), ('20160824063747'), ('20160824063809'), ('20160824082547'), ('20160824092957');


