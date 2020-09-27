SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: actions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.actions (
    id integer NOT NULL,
    longitude numeric(9,6) DEFAULT 0.0,
    latitude numeric(9,6) DEFAULT 0.0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    actionable_type character varying,
    actionable_id integer,
    user_id integer,
    distance integer DEFAULT 0,
    action_type integer DEFAULT 0
);


--
-- Name: actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.actions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.actions_id_seq OWNED BY public.actions.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    title character varying,
    place character varying,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    content text DEFAULT ''::text,
    longitude numeric(9,6) DEFAULT 0.0,
    latitude numeric(9,6) DEFAULT 0.0,
    distance integer DEFAULT 0,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    price numeric(10,2) DEFAULT 0.0
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: app_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_versions (
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

CREATE SEQUENCE public.app_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_versions_id_seq OWNED BY public.app_versions.id;


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
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.articles (
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

CREATE SEQUENCE public.articles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;


--
-- Name: bikes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bikes (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying,
    module_id character varying NOT NULL,
    longitude numeric(9,6) DEFAULT 0.0,
    latitude numeric(9,6) DEFAULT 0.0,
    battery numeric(6,2) DEFAULT 0.0,
    travel_mileage numeric(10,2) DEFAULT 0.0,
    diag_info public.hstore DEFAULT ''::public.hstore,
    user_id integer,
    iccid character varying,
    commands public.hstore DEFAULT ''::public.hstore,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bikes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bikes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bikes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bikes_id_seq OWNED BY public.bikes.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    living_id integer,
    user_id integer,
    reply_to_user_id integer,
    content text DEFAULT ''::text
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id integer NOT NULL,
    title character varying,
    content text DEFAULT ''::text,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    longitude numeric(9,6) DEFAULT 0.0,
    latitude numeric(9,6) DEFAULT 0.0,
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

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: friendships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendships (
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

CREATE SEQUENCE public.friendships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friendships_id_seq OWNED BY public.friendships.id;


--
-- Name: image_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.image_attachments (
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

CREATE SEQUENCE public.image_attachments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: image_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.image_attachments_id_seq OWNED BY public.image_attachments.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.likes (
    id integer NOT NULL,
    living_id integer,
    user_id integer
);


--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.likes_id_seq OWNED BY public.likes.id;


--
-- Name: livings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.livings (
    id integer NOT NULL,
    title character varying,
    place character varying,
    content text DEFAULT ''::text,
    longitude numeric(9,6) DEFAULT 0.0,
    latitude numeric(9,6) DEFAULT 0.0,
    distance integer DEFAULT 0,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    price numeric(10,2) DEFAULT 0.0
);


--
-- Name: livings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.livings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: livings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.livings_id_seq OWNED BY public.livings.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
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

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media (
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

CREATE SEQUENCE public.media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_id_seq OWNED BY public.media.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    user_id integer,
    message_object_type character varying,
    message_object_id integer,
    is_read boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: oauth_access_grants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_access_grants (
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

CREATE SEQUENCE public.oauth_access_grants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_access_grants_id_seq OWNED BY public.oauth_access_grants.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_access_tokens (
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

CREATE SEQUENCE public.oauth_access_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_access_tokens_id_seq OWNED BY public.oauth_access_tokens.id;


--
-- Name: oauth_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_applications (
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
    mongo_id character varying,
    confidential boolean DEFAULT true NOT NULL
);


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_applications_id_seq OWNED BY public.oauth_applications.id;


--
-- Name: order_takes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_takes (
    id integer NOT NULL,
    take_along_something_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: order_takes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_takes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_takes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_takes_id_seq OWNED BY public.order_takes.id;


--
-- Name: participations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participations (
    id integer NOT NULL,
    activity_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: participations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.participations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.participations_id_seq OWNED BY public.participations.id;


--
-- Name: passing_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.passing_locations (
    id integer NOT NULL,
    longitude numeric(9,6) NOT NULL,
    latitude numeric(9,6) NOT NULL,
    travel_plan_id integer
);


--
-- Name: passing_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.passing_locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: passing_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.passing_locations_id_seq OWNED BY public.passing_locations.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
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

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: receivers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receivers (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying,
    phone character varying DEFAULT ''::character varying,
    address character varying DEFAULT ''::character varying,
    take_along_something_id integer,
    longitude numeric(9,6) DEFAULT 0.0,
    latitude numeric(9,6) DEFAULT 0.0,
    place character varying DEFAULT ''::character varying
);


--
-- Name: receivers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.receivers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receivers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.receivers_id_seq OWNED BY public.receivers.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: senders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.senders (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying,
    phone character varying DEFAULT ''::character varying,
    address character varying DEFAULT ''::character varying,
    take_along_something_id integer,
    longitude numeric(9,6) DEFAULT 0.0,
    latitude numeric(9,6) DEFAULT 0.0,
    place character varying DEFAULT ''::character varying
);


--
-- Name: senders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.senders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: senders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.senders_id_seq OWNED BY public.senders.id;


--
-- Name: sms_validation_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sms_validation_codes (
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

CREATE SEQUENCE public.sms_validation_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sms_validation_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sms_validation_codes_id_seq OWNED BY public.sms_validation_codes.id;


--
-- Name: take_along_somethings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.take_along_somethings (
    id integer NOT NULL,
    title character varying,
    place character varying,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    content text DEFAULT ''::text,
    price numeric(10,2) DEFAULT 0.0,
    longitude numeric(9,6) DEFAULT 0.0,
    latitude numeric(9,6) DEFAULT 0.0,
    distance integer DEFAULT 0,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: take_along_somethings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.take_along_somethings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: take_along_somethings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.take_along_somethings_id_seq OWNED BY public.take_along_somethings.id;


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topics (
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

CREATE SEQUENCE public.topics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.topics_id_seq OWNED BY public.topics.id;


--
-- Name: travel_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.travel_plans (
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

CREATE SEQUENCE public.travel_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: travel_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.travel_plans_id_seq OWNED BY public.travel_plans.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
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
    longitude numeric(9,6) DEFAULT 0.0 NOT NULL,
    latitude numeric(9,6) DEFAULT 0.0 NOT NULL,
    mongo_id character varying,
    title character varying,
    level character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: video_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.video_attachments (
    id integer NOT NULL,
    file character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    living_id integer
);


--
-- Name: video_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.video_attachments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: video_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.video_attachments_id_seq OWNED BY public.video_attachments.id;


--
-- Name: actions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.actions ALTER COLUMN id SET DEFAULT nextval('public.actions_id_seq'::regclass);


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: app_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_versions ALTER COLUMN id SET DEFAULT nextval('public.app_versions_id_seq'::regclass);


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- Name: bikes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bikes ALTER COLUMN id SET DEFAULT nextval('public.bikes_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: friendships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendships ALTER COLUMN id SET DEFAULT nextval('public.friendships_id_seq'::regclass);


--
-- Name: image_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_attachments ALTER COLUMN id SET DEFAULT nextval('public.image_attachments_id_seq'::regclass);


--
-- Name: likes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes ALTER COLUMN id SET DEFAULT nextval('public.likes_id_seq'::regclass);


--
-- Name: livings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livings ALTER COLUMN id SET DEFAULT nextval('public.livings_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: media id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media ALTER COLUMN id SET DEFAULT nextval('public.media_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: oauth_access_grants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('public.oauth_access_grants_id_seq'::regclass);


--
-- Name: oauth_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.oauth_access_tokens_id_seq'::regclass);


--
-- Name: oauth_applications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_applications ALTER COLUMN id SET DEFAULT nextval('public.oauth_applications_id_seq'::regclass);


--
-- Name: order_takes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_takes ALTER COLUMN id SET DEFAULT nextval('public.order_takes_id_seq'::regclass);


--
-- Name: participations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participations ALTER COLUMN id SET DEFAULT nextval('public.participations_id_seq'::regclass);


--
-- Name: passing_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passing_locations ALTER COLUMN id SET DEFAULT nextval('public.passing_locations_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: receivers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receivers ALTER COLUMN id SET DEFAULT nextval('public.receivers_id_seq'::regclass);


--
-- Name: senders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.senders ALTER COLUMN id SET DEFAULT nextval('public.senders_id_seq'::regclass);


--
-- Name: sms_validation_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sms_validation_codes ALTER COLUMN id SET DEFAULT nextval('public.sms_validation_codes_id_seq'::regclass);


--
-- Name: take_along_somethings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.take_along_somethings ALTER COLUMN id SET DEFAULT nextval('public.take_along_somethings_id_seq'::regclass);


--
-- Name: topics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics ALTER COLUMN id SET DEFAULT nextval('public.topics_id_seq'::regclass);


--
-- Name: travel_plans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.travel_plans ALTER COLUMN id SET DEFAULT nextval('public.travel_plans_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: video_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_attachments ALTER COLUMN id SET DEFAULT nextval('public.video_attachments_id_seq'::regclass);


--
-- Name: actions actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.actions
    ADD CONSTRAINT actions_pkey PRIMARY KEY (id);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: app_versions app_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_versions
    ADD CONSTRAINT app_versions_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: bikes bikes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bikes
    ADD CONSTRAINT bikes_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: friendships friendships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_pkey PRIMARY KEY (id);


--
-- Name: image_attachments image_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_attachments
    ADD CONSTRAINT image_attachments_pkey PRIMARY KEY (id);


--
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: livings livings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.livings
    ADD CONSTRAINT livings_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_grants oauth_access_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth_applications oauth_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);


--
-- Name: order_takes order_takes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_takes
    ADD CONSTRAINT order_takes_pkey PRIMARY KEY (id);


--
-- Name: participations participations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participations
    ADD CONSTRAINT participations_pkey PRIMARY KEY (id);


--
-- Name: passing_locations passing_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.passing_locations
    ADD CONSTRAINT passing_locations_pkey PRIMARY KEY (id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: receivers receivers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receivers
    ADD CONSTRAINT receivers_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: senders senders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.senders
    ADD CONSTRAINT senders_pkey PRIMARY KEY (id);


--
-- Name: sms_validation_codes sms_validation_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sms_validation_codes
    ADD CONSTRAINT sms_validation_codes_pkey PRIMARY KEY (id);


--
-- Name: take_along_somethings take_along_somethings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.take_along_somethings
    ADD CONSTRAINT take_along_somethings_pkey PRIMARY KEY (id);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: travel_plans travel_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.travel_plans
    ADD CONSTRAINT travel_plans_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: video_attachments video_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_attachments
    ADD CONSTRAINT video_attachments_pkey PRIMARY KEY (id);


--
-- Name: index_actions_on_actionable_type_and_actionable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_actions_on_actionable_type_and_actionable_id ON public.actions USING btree (actionable_type, actionable_id);


--
-- Name: index_actions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_actions_on_user_id ON public.actions USING btree (user_id);


--
-- Name: index_activities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_user_id ON public.activities USING btree (user_id);


--
-- Name: index_bikes_on_commands; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_commands ON public.bikes USING gin (commands);


--
-- Name: index_bikes_on_diag_info; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_diag_info ON public.bikes USING gin (diag_info);


--
-- Name: index_bikes_on_module_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_bikes_on_module_id ON public.bikes USING btree (module_id);


--
-- Name: index_bikes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bikes_on_user_id ON public.bikes USING btree (user_id);


--
-- Name: index_comments_on_living_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_living_id ON public.comments USING btree (living_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_events_on_actionable_type_and_actionable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_actionable_type_and_actionable_id ON public.events USING btree (actionable_type, actionable_id);


--
-- Name: index_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_user_id ON public.events USING btree (user_id);


--
-- Name: index_friendships_on_friend_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendships_on_friend_id ON public.friendships USING btree (friend_id);


--
-- Name: index_friendships_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendships_on_status ON public.friendships USING btree (status);


--
-- Name: index_friendships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendships_on_user_id ON public.friendships USING btree (user_id);


--
-- Name: index_image_attachments_on_imageable_type_and_imageable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_image_attachments_on_imageable_type_and_imageable_id ON public.image_attachments USING btree (imageable_type, imageable_id);


--
-- Name: index_likes_on_living_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_likes_on_living_id ON public.likes USING btree (living_id);


--
-- Name: index_likes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_likes_on_user_id ON public.likes USING btree (user_id);


--
-- Name: index_livings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_livings_on_user_id ON public.livings USING btree (user_id);


--
-- Name: index_locations_on_bike_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_bike_id ON public.locations USING btree (bike_id);


--
-- Name: index_media_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_media_on_user_id ON public.media USING btree (user_id);


--
-- Name: index_messages_on_message_object_type_and_message_object_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_message_object_type_and_message_object_id ON public.messages USING btree (message_object_type, message_object_id);


--
-- Name: index_messages_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_user_id ON public.messages USING btree (user_id);


--
-- Name: index_oauth_access_grants_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_grants_on_application_id ON public.oauth_access_grants USING btree (application_id);


--
-- Name: index_oauth_access_grants_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON public.oauth_access_grants USING btree (token);


--
-- Name: index_oauth_access_tokens_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_tokens_on_application_id ON public.oauth_access_tokens USING btree (application_id);


--
-- Name: index_oauth_access_tokens_on_refresh_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON public.oauth_access_tokens USING btree (refresh_token);


--
-- Name: index_oauth_access_tokens_on_resource_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON public.oauth_access_tokens USING btree (resource_owner_id);


--
-- Name: index_oauth_access_tokens_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON public.oauth_access_tokens USING btree (token);


--
-- Name: index_oauth_applications_on_owner_id_and_owner_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_applications_on_owner_id_and_owner_type ON public.oauth_applications USING btree (owner_id, owner_type);


--
-- Name: index_oauth_applications_on_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_applications_on_uid ON public.oauth_applications USING btree (uid);


--
-- Name: index_on_actions_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_actions_location ON public.actions USING gist (public.st_geographyfromtext((((('SRID=4326;POINT('::text || longitude) || ' '::text) || latitude) || ')'::text)));


--
-- Name: index_on_activities_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_activities_location ON public.activities USING gist (public.st_geographyfromtext((((('SRID=4326;POINT('::text || longitude) || ' '::text) || latitude) || ')'::text)));


--
-- Name: index_on_livings_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_livings_location ON public.livings USING gist (public.st_geographyfromtext((((('SRID=4326;POINT('::text || longitude) || ' '::text) || latitude) || ')'::text)));


--
-- Name: index_on_take_along_somethings_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_on_take_along_somethings_location ON public.take_along_somethings USING gist (public.st_geographyfromtext((((('SRID=4326;POINT('::text || longitude) || ' '::text) || latitude) || ')'::text)));


--
-- Name: index_order_takes_on_take_along_something_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_takes_on_take_along_something_id ON public.order_takes USING btree (take_along_something_id);


--
-- Name: index_order_takes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_order_takes_on_user_id ON public.order_takes USING btree (user_id);


--
-- Name: index_participations_on_activity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participations_on_activity_id ON public.participations USING btree (activity_id);


--
-- Name: index_participations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participations_on_user_id ON public.participations USING btree (user_id);


--
-- Name: index_passing_locations_on_travel_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_passing_locations_on_travel_plan_id ON public.passing_locations USING btree (travel_plan_id);


--
-- Name: index_posts_on_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_topic_id ON public.posts USING btree (topic_id);


--
-- Name: index_posts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_user_id ON public.posts USING btree (user_id);


--
-- Name: index_receivers_on_take_along_something_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_receivers_on_take_along_something_id ON public.receivers USING btree (take_along_something_id);


--
-- Name: index_senders_on_take_along_something_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_senders_on_take_along_something_id ON public.senders USING btree (take_along_something_id);


--
-- Name: index_take_along_somethings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_take_along_somethings_on_user_id ON public.take_along_somethings USING btree (user_id);


--
-- Name: index_topics_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_topics_on_user_id ON public.topics USING btree (user_id);


--
-- Name: index_travel_plans_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_travel_plans_on_user_id ON public.travel_plans USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_name ON public.users USING btree (name);


--
-- Name: index_users_on_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_phone ON public.users USING btree (phone);


--
-- Name: index_video_attachments_on_living_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_video_attachments_on_living_id ON public.video_attachments USING btree (living_id);


--
-- Name: comments fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: likes fk_rails_1e09b5dabf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fk_rails_1e09b5dabf FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: comments fk_rails_431da59358; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_431da59358 FOREIGN KEY (living_id) REFERENCES public.livings(id);


--
-- Name: order_takes fk_rails_45f6b6dc45; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_takes
    ADD CONSTRAINT fk_rails_45f6b6dc45 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: order_takes fk_rails_7309fb7a55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_takes
    ADD CONSTRAINT fk_rails_7309fb7a55 FOREIGN KEY (take_along_something_id) REFERENCES public.take_along_somethings(id);


--
-- Name: oauth_access_tokens fk_rails_732cb83ab7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens
    ADD CONSTRAINT fk_rails_732cb83ab7 FOREIGN KEY (application_id) REFERENCES public.oauth_applications(id);


--
-- Name: video_attachments fk_rails_7497d0a785; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.video_attachments
    ADD CONSTRAINT fk_rails_7497d0a785 FOREIGN KEY (living_id) REFERENCES public.livings(id);


--
-- Name: participations fk_rails_92013479b0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participations
    ADD CONSTRAINT fk_rails_92013479b0 FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- Name: oauth_access_grants fk_rails_b4b53e07b8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants
    ADD CONSTRAINT fk_rails_b4b53e07b8 FOREIGN KEY (application_id) REFERENCES public.oauth_applications(id);


--
-- Name: likes fk_rails_e40c4ecbfa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fk_rails_e40c4ecbfa FOREIGN KEY (living_id) REFERENCES public.livings(id);


--
-- Name: participations fk_rails_e80f5ca3a2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participations
    ADD CONSTRAINT fk_rails_e80f5ca3a2 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20160523091904'),
('20160525071248'),
('20160525082438'),
('20160606035233'),
('20160613062612'),
('20160614015218'),
('20160726080254'),
('20160808024844'),
('20160808055827'),
('20160808072134'),
('20160822060130'),
('20160822060641'),
('20160822060908'),
('20160822063724'),
('20160822063741'),
('20160822072047'),
('20160822072115'),
('20160822072620'),
('20160822074629'),
('20160822074719'),
('20160822074903'),
('20160822075347'),
('20160822075429'),
('20160822081855'),
('20160823074345'),
('20160823074410'),
('20160823074419'),
('20160823075554'),
('20160823083109'),
('20160824063747'),
('20160824063809'),
('20160824082547'),
('20160824092957'),
('20160826082432'),
('20160830022613'),
('20160830024040'),
('20160920052608'),
('20160920075205'),
('20161009070034'),
('20161114061215'),
('20200927040636');


