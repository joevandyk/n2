--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE announcements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: announcements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE announcements (
    id integer DEFAULT nextval('announcements_id_seq'::regclass) NOT NULL,
    prefix character varying(255),
    title character varying(255) NOT NULL,
    details text,
    url character varying(255),
    mode character varying(255) DEFAULT 'rotate'::character varying,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE answers (
    id integer DEFAULT nextval('answers_id_seq'::regclass) NOT NULL,
    question_id integer DEFAULT 0,
    user_id bigint DEFAULT 0,
    answer text,
    votes_tally integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    site_id integer
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
-- Name: articles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE articles (
    id integer DEFAULT nextval('articles_id_seq'::regclass) NOT NULL,
    user_id integer,
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    author_id integer,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    is_draft boolean DEFAULT false,
    preamble text,
    preamble_complete boolean DEFAULT false,
    site_id integer
);


--
-- Name: audios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE audios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audios; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE audios (
    id integer DEFAULT nextval('audios_id_seq'::regclass) NOT NULL,
    audioable_type character varying(255),
    audioable_id integer,
    user_id integer,
    url character varying(255),
    title character varying(255),
    artist character varying(255),
    album character varying(255),
    caption text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    votes_tally integer DEFAULT 0,
    source_id integer,
    is_blocked boolean DEFAULT false,
    embed_code text,
    site_id integer
);


--
-- Name: authentications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authentications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authentications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE authentications (
    id integer DEFAULT nextval('authentications_id_seq'::regclass) NOT NULL,
    user_id integer,
    provider character varying(255),
    uid character varying(255),
    credentials_token character varying(255),
    credentials_secret character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    nickname character varying(255),
    description character varying(255),
    raw_output text,
    site_id integer
);


--
-- Name: cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cards (
    id integer DEFAULT nextval('cards_id_seq'::regclass) NOT NULL,
    name character varying(255),
    short_caption character varying(255),
    long_caption text,
    points integer DEFAULT 0,
    slug_name character varying(255),
    not_sendable boolean DEFAULT false,
    is_featured boolean DEFAULT false,
    updated_at timestamp without time zone,
    sent_count integer DEFAULT 0,
    created_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer DEFAULT nextval('categories_id_seq'::regclass) NOT NULL,
    categorizable_type character varying(255),
    parent_id integer,
    name character varying(255),
    context character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: categorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categorizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categorizations (
    id integer DEFAULT nextval('categorizations_id_seq'::regclass) NOT NULL,
    category_id integer,
    categorizable_id integer,
    categorizable_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: chirps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE chirps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chirps; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE chirps (
    id integer DEFAULT nextval('chirps_id_seq'::regclass) NOT NULL,
    user_id integer,
    recipient_id integer,
    subject character varying(255),
    message text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: classifieds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE classifieds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classifieds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE classifieds (
    id integer DEFAULT nextval('classifieds_id_seq'::regclass) NOT NULL,
    title character varying(255),
    details text,
    aasm_state character varying(255),
    listing_type character varying(255),
    allow character varying(255),
    amazon_asin character varying(255),
    user_id integer,
    expires_at timestamp without time zone,
    price numeric(11,0),
    votes_tally integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    flags_count integer DEFAULT 0,
    is_blocked boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    location_text character varying(255),
    site_id integer
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer DEFAULT nextval('comments_id_seq'::regclass) NOT NULL,
    commentid integer DEFAULT 0,
    commentable_id integer DEFAULT 0,
    contentid integer DEFAULT 0,
    comments text,
    "postedByName" character varying(255) DEFAULT ''::character varying,
    "postedById" integer DEFAULT 0,
    user_id integer DEFAULT 0,
    created_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    videoid integer DEFAULT 0,
    updated_at timestamp without time zone,
    commentable_type character varying(255),
    flags_count integer DEFAULT 0,
    votes_tally integer DEFAULT 0,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    site_id integer
);


--
-- Name: consumer_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE consumer_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: consumer_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE consumer_tokens (
    id integer DEFAULT nextval('consumer_tokens_id_seq'::regclass) NOT NULL,
    user_id integer,
    type character varying(30),
    token character varying(1024),
    secret character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: content_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE content_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE content_images (
    id integer DEFAULT nextval('content_images_id_seq'::regclass) NOT NULL,
    url character varying(255) DEFAULT ''::character varying,
    content_id integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: contents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contents (
    id integer DEFAULT nextval('contents_id_seq'::regclass) NOT NULL,
    contentid integer DEFAULT 0,
    title character varying(255) DEFAULT ''::character varying,
    caption text,
    url character varying(255) DEFAULT ''::character varying,
    permalink character varying(255) DEFAULT ''::character varying,
    "postedById" integer DEFAULT 0,
    "postedByName" character varying(255) DEFAULT ''::character varying,
    created_at timestamp without time zone,
    score integer DEFAULT 0,
    "numComments" integer DEFAULT 0,
    is_featured boolean DEFAULT false,
    user_id integer DEFAULT 0,
    imageid integer DEFAULT 0,
    "videoIntroId" integer DEFAULT 0,
    is_blocked boolean DEFAULT false,
    videoid integer DEFAULT 0,
    widgetid integer DEFAULT 0,
    "isBlogEntry" boolean DEFAULT false,
    "isFeatureCandidate" boolean DEFAULT false,
    comments_count integer DEFAULT 0,
    updated_at timestamp without time zone,
    article_id integer,
    cached_slug character varying(255),
    flags_count integer DEFAULT 0,
    votes_tally integer DEFAULT 0,
    newswire_id integer,
    story_type character varying(255) DEFAULT 'story'::character varying,
    summary character varying(255),
    full_html text,
    source_id integer,
    site_id integer
);


--
-- Name: dashboard_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dashboard_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dashboard_messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE dashboard_messages (
    id integer DEFAULT nextval('dashboard_messages_id_seq'::regclass) NOT NULL,
    message character varying(255),
    action_text character varying(255),
    action_url character varying(255),
    image_url character varying(255),
    status character varying(255) DEFAULT 'draft'::character varying,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    news_id integer,
    is_blocked boolean DEFAULT false,
    site_id integer
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
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
    id integer DEFAULT nextval('events_id_seq'::regclass) NOT NULL,
    eid character varying(255),
    name character varying(255),
    tagline character varying(255),
    pic character varying(255),
    pic_big character varying(255),
    pic_small character varying(255),
    host character varying(255),
    location character varying(255),
    street character varying(255),
    city character varying(255),
    state character varying(255),
    country character varying(255),
    description text,
    event_type character varying(255),
    event_subtype character varying(255),
    privacy_type character varying(255),
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    update_time timestamp without time zone,
    "isApproved" boolean,
    nid integer,
    creator integer,
    user_id integer,
    votes_tally integer,
    comments_count integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    flags_count integer DEFAULT 0,
    url character varying(255),
    alt_url character varying(255),
    source character varying(255),
    site_id integer
);


--
-- Name: fbsessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE fbsessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fbSessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "fbSessions" (
    id integer DEFAULT nextval('fbsessions_id_seq'::regclass) NOT NULL,
    userid bigint DEFAULT 0,
    "fbId" bigint DEFAULT 0,
    fb_sig_session_key character varying(255) DEFAULT ''::character varying,
    fb_sig_time timestamp without time zone,
    fb_sig_expires timestamp without time zone,
    fb_sig_profile_update_time timestamp without time zone,
    site_id integer
);


--
-- Name: featured_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE featured_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: featured_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE featured_items (
    id integer DEFAULT nextval('featured_items_id_seq'::regclass) NOT NULL,
    parent_id integer,
    featurable_id integer,
    featurable_type character varying(255),
    featured_type character varying(255),
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: feeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feeds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feeds (
    id integer DEFAULT nextval('feeds_id_seq'::regclass) NOT NULL,
    wireid integer DEFAULT 0,
    title character varying(255) DEFAULT ''::character varying,
    url character varying(255) DEFAULT ''::character varying,
    rss character varying(255) DEFAULT ''::character varying,
    last_fetched_at timestamp without time zone,
    "feedType" character varying(255) DEFAULT 'wire'::character varying,
    "specialType" character varying(255) DEFAULT 'default'::character varying,
    "loadOptions" character varying(255) DEFAULT 'none'::character varying,
    user_id bigint DEFAULT 0,
    "tagList" character varying(255) DEFAULT ''::character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    load_all boolean DEFAULT false,
    deleted_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    enabled boolean DEFAULT true,
    newswires_count integer DEFAULT 0,
    site_id integer
);


--
-- Name: flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE flags (
    id integer DEFAULT nextval('flags_id_seq'::regclass) NOT NULL,
    flag_type character varying(255),
    user_id integer,
    flaggable_type character varying(255),
    flaggable_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: forums_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forums; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forums (
    id integer DEFAULT nextval('forums_id_seq'::regclass) NOT NULL,
    name character varying(255),
    description character varying(255),
    topics_count integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    "position" integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    site_id integer
);


--
-- Name: galleries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE galleries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: galleries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE galleries (
    id integer DEFAULT nextval('galleries_id_seq'::regclass) NOT NULL,
    title character varying(255),
    description text,
    user_id integer,
    is_public boolean DEFAULT false,
    votes_tally integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    flags_count integer DEFAULT 0,
    is_blocked boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: gallery_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gallery_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gallery_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gallery_items (
    id integer DEFAULT nextval('gallery_items_id_seq'::regclass) NOT NULL,
    galleryable_type character varying(255),
    galleryable_id integer,
    user_id integer,
    gallery_id integer,
    title character varying(255),
    cached_slug character varying(255),
    caption text,
    item_url character varying(255),
    "position" integer DEFAULT 0,
    votes_tally integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    flags_count integer DEFAULT 0,
    is_blocked boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: gos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gos (
    id integer DEFAULT nextval('gos_id_seq'::regclass) NOT NULL,
    goable_type character varying(255),
    goable_id integer,
    user_id integer,
    name character varying(255),
    cached_slug character varying(255),
    views_count integer DEFAULT 0,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    flags_count integer DEFAULT 0,
    is_blocked boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: idea_boards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE idea_boards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: idea_boards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE idea_boards (
    id integer DEFAULT nextval('idea_boards_id_seq'::regclass) NOT NULL,
    name character varying(255),
    section character varying(255),
    description character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: ideas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ideas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ideas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ideas (
    id integer DEFAULT nextval('ideas_id_seq'::regclass) NOT NULL,
    user_id bigint DEFAULT 0,
    title character varying(255) DEFAULT ''::character varying,
    details text,
    old_tag_id integer DEFAULT 0,
    old_video_id integer DEFAULT 0,
    votes_tally integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    idea_board_id integer,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    flags_count integer DEFAULT 0,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE images (
    id integer DEFAULT nextval('images_id_seq'::regclass) NOT NULL,
    imageable_type character varying(255),
    imageable_id integer,
    user_id integer,
    description text,
    remote_image_url character varying(255),
    is_blocked boolean DEFAULT false,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    votes_tally integer DEFAULT 0,
    title character varying(255),
    source_id integer,
    site_id integer
);


--
-- Name: item_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE item_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_actions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE item_actions (
    id integer DEFAULT nextval('item_actions_id_seq'::regclass) NOT NULL,
    actionable_type character varying(255),
    actionable_id integer,
    user_id integer,
    action_type character varying(255),
    url character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: item_tweets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE item_tweets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_tweets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE item_tweets (
    id integer DEFAULT nextval('item_tweets_id_seq'::regclass) NOT NULL,
    item_type character varying(255),
    item_id integer,
    tweet_id integer,
    primary_item boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: locales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locales; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locales (
    id integer DEFAULT nextval('locales_id_seq'::regclass) NOT NULL,
    code character varying(255),
    name character varying(255),
    site_id integer
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages (
    id integer DEFAULT nextval('messages_id_seq'::regclass) NOT NULL,
    subject character varying(255),
    email character varying(255),
    body text,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: metadatas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE metadatas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metadatas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE metadatas (
    id integer DEFAULT nextval('metadatas_id_seq'::regclass) NOT NULL,
    metadatable_type character varying(255),
    metadatable_id integer,
    key_name character varying(255),
    key_type character varying(255),
    meta_type character varying(255),
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    key_sub_type character varying(255),
    type character varying(255),
    site_id integer
);


--
-- Name: newswires_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE newswires_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: newswires; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE newswires (
    id integer DEFAULT nextval('newswires_id_seq'::regclass) NOT NULL,
    title character varying(255) DEFAULT ''::character varying,
    caption text,
    source character varying(150) DEFAULT ''::character varying,
    url character varying(255) DEFAULT ''::character varying,
    created_at timestamp without time zone,
    wireid integer DEFAULT 0,
    "feedType" character varying(255) DEFAULT 'wire'::character varying,
    "mediaUrl" character varying(255) DEFAULT ''::character varying,
    "imageUrl" character varying(255) DEFAULT ''::character varying,
    embed text,
    feed_id integer DEFAULT 0,
    updated_at timestamp without time zone,
    published boolean DEFAULT false,
    read_count integer,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: pfeed_deliveries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pfeed_deliveries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pfeed_deliveries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pfeed_deliveries (
    id integer DEFAULT nextval('pfeed_deliveries_id_seq'::regclass) NOT NULL,
    pfeed_receiver_id integer,
    pfeed_receiver_type character varying(255),
    pfeed_item_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: pfeed_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pfeed_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pfeed_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pfeed_items (
    id integer DEFAULT nextval('pfeed_items_id_seq'::regclass) NOT NULL,
    type character varying(255),
    originator_id integer,
    originator_type character varying(255),
    participant_id integer,
    participant_type character varying(255),
    data text,
    expiry timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: prediction_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prediction_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prediction_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prediction_groups (
    id integer DEFAULT nextval('prediction_groups_id_seq'::regclass) NOT NULL,
    title character varying(255),
    section character varying(255),
    description text,
    status character varying(255) DEFAULT 'open'::character varying,
    user_id integer,
    is_approved boolean DEFAULT true,
    votes_tally integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    questions_count integer DEFAULT 0,
    is_blocked boolean DEFAULT false,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    prediction_questions_count integer DEFAULT 0,
    site_id integer
);


--
-- Name: prediction_guesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prediction_guesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prediction_guesses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prediction_guesses (
    id integer DEFAULT nextval('prediction_guesses_id_seq'::regclass) NOT NULL,
    prediction_question_id integer,
    user_id integer,
    guess character varying(255),
    guess_numeric integer,
    guess_date timestamp without time zone,
    is_blocked boolean DEFAULT false,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_correct boolean DEFAULT false,
    site_id integer
);


--
-- Name: prediction_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prediction_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prediction_questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prediction_questions (
    id integer DEFAULT nextval('prediction_questions_id_seq'::regclass) NOT NULL,
    prediction_group_id integer,
    title character varying(255),
    prediction_type character varying(255),
    choices character varying(255),
    status character varying(255) DEFAULT 'open'::character varying,
    user_id integer,
    is_approved boolean DEFAULT true,
    votes_tally integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    guesses_count integer DEFAULT 0,
    is_blocked boolean DEFAULT false,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    prediction_guesses_count integer DEFAULT 0
);


--
-- Name: prediction_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prediction_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prediction_results; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prediction_results (
    id integer DEFAULT nextval('prediction_results_id_seq'::regclass) NOT NULL,
    prediction_question_id integer,
    result character varying(255),
    details text,
    url character varying(255),
    user_id integer,
    is_accepted boolean DEFAULT false,
    accepted_at timestamp without time zone,
    accepted_by_user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    alternate_result character varying(255),
    site_id integer
);


--
-- Name: prediction_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prediction_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prediction_scores; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prediction_scores (
    id integer DEFAULT nextval('prediction_scores_id_seq'::regclass) NOT NULL,
    user_id integer,
    guess_count integer,
    correct_count integer,
    accuracy numeric(11,0),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer DEFAULT nextval('questions_id_seq'::regclass) NOT NULL,
    user_id bigint DEFAULT 0,
    question character varying(255) DEFAULT ''::character varying,
    details text,
    votes_tally integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    created_at timestamp without time zone,
    answers_count integer DEFAULT 0,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    site_id integer
);


--
-- Name: related_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE related_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: related_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE related_items (
    id integer DEFAULT nextval('related_items_id_seq'::regclass) NOT NULL,
    title character varying(255),
    url character varying(255),
    notes text,
    user_id integer,
    is_blocked boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    relatable_type character varying(255),
    relatable_id integer,
    site_id integer
);


--
-- Name: resource_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resource_sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_sections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE resource_sections (
    id integer DEFAULT nextval('resource_sections_id_seq'::regclass) NOT NULL,
    name character varying(255),
    section character varying(255),
    description character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE resources (
    id integer DEFAULT nextval('resources_id_seq'::regclass) NOT NULL,
    title character varying(255) NOT NULL,
    details text,
    url character varying(255),
    "mapUrl" character varying(255),
    "twitterName" character varying(255),
    votes_tally integer,
    comments_count integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    flags_count integer DEFAULT 0,
    resource_section_id integer,
    is_blocked boolean DEFAULT false,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    is_sponsored boolean DEFAULT false
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer DEFAULT nextval('roles_id_seq'::regclass) NOT NULL,
    name character varying(255),
    authorizable_type character varying(255),
    authorizable_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: roles_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles_users (
    user_id integer,
    role_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scores; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE scores (
    id integer DEFAULT nextval('scores_id_seq'::regclass) NOT NULL,
    user_id integer,
    scorable_type character varying(255),
    scorable_id integer,
    score_type character varying(255),
    value integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: sent_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sent_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sent_cards; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sent_cards (
    id integer DEFAULT nextval('sent_cards_id_seq'::regclass) NOT NULL,
    from_user_id integer,
    to_fb_user_id bigint,
    card_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id integer DEFAULT nextval('sessions_id_seq'::regclass) NOT NULL,
    session_id character varying(255) NOT NULL,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sites (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    domain character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE slugs (
    id integer DEFAULT nextval('slugs_id_seq'::regclass) NOT NULL,
    name character varying(255),
    sluggable_id integer,
    sequence integer DEFAULT 1 NOT NULL,
    sluggable_type character varying(40),
    scope character varying(40),
    created_at timestamp without time zone,
    site_id integer
);


--
-- Name: sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sources (
    id integer DEFAULT nextval('sources_id_seq'::regclass) NOT NULL,
    name character varying(255),
    url character varying(255),
    all_subdomains_valid boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    white_list boolean DEFAULT false,
    black_list boolean DEFAULT false,
    site_id integer
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer DEFAULT nextval('taggings_id_seq'::regclass) NOT NULL,
    tag_id integer,
    taggable_id integer,
    tagger_id integer,
    tagger_type character varying(255),
    taggable_type character varying(255),
    context character varying(255),
    created_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer DEFAULT nextval('tags_id_seq'::regclass) NOT NULL,
    name character varying(255),
    is_blocked boolean DEFAULT false,
    site_id integer
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
-- Name: topics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE topics (
    id integer DEFAULT nextval('topics_id_seq'::regclass) NOT NULL,
    forum_id integer,
    user_id integer,
    title character varying(255),
    views_count integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    replied_at timestamp without time zone,
    replied_user_id integer,
    sticky integer DEFAULT 0,
    last_comment_id integer,
    locked boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    flags_count integer DEFAULT 0,
    site_id integer
);


--
-- Name: translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: translations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE translations (
    id integer DEFAULT nextval('translations_id_seq'::regclass) NOT NULL,
    key character varying(255),
    raw_key text,
    value text,
    pluralization_index integer DEFAULT 1,
    locale_id integer,
    site_id integer
);


--
-- Name: tweet_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tweet_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tweet_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tweet_accounts (
    id integer DEFAULT nextval('tweet_accounts_id_seq'::regclass) NOT NULL,
    user_id integer,
    twitter_id_str character varying(255),
    name character varying(255),
    screen_name character varying(255),
    profile_image_url character varying(255),
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: tweet_streams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tweet_streams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tweet_streams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tweet_streams (
    id integer DEFAULT nextval('tweet_streams_id_seq'::regclass) NOT NULL,
    list_name character varying(255),
    list_username character varying(255),
    twitter_id_str character varying(255),
    description text,
    last_fetched_at timestamp without time zone,
    last_fetched_tweet_id integer,
    tweets_count integer DEFAULT 0,
    votes_tally integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    flags_count integer DEFAULT 0,
    is_blocked boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: tweet_urls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tweet_urls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tweet_urls; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tweet_urls (
    id integer DEFAULT nextval('tweet_urls_id_seq'::regclass) NOT NULL,
    tweet_id integer,
    url_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: tweeted_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tweeted_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tweeted_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tweeted_items (
    id integer DEFAULT nextval('tweeted_items_id_seq'::regclass) NOT NULL,
    item_type character varying(255),
    item_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: tweets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tweets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tweets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tweets (
    id integer DEFAULT nextval('tweets_id_seq'::regclass) NOT NULL,
    tweet_item_type character varying(255),
    tweet_item_id integer,
    tweet_stream_id integer,
    tweet_account_id integer,
    twitter_id_str character varying(255),
    text character varying(255),
    raw_tweet text,
    votes_tally integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    flags_count integer DEFAULT 0,
    is_blocked boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: urls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE urls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: urls; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE urls (
    id integer DEFAULT nextval('urls_id_seq'::regclass) NOT NULL,
    source_id integer,
    url character varying(255),
    votes_tally integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    is_featured boolean DEFAULT false,
    featured_at timestamp without time zone,
    flags_count integer DEFAULT 0,
    is_blocked boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: user_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_profiles (
    id integer DEFAULT nextval('user_profiles_id_seq'::regclass) NOT NULL,
    user_id bigint NOT NULL,
    facebook_user_id bigint DEFAULT 0,
    "isAppAuthorized" boolean DEFAULT false,
    born_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    bio text,
    referred_by_user_id bigint DEFAULT 0,
    comment_notifications boolean DEFAULT false,
    receive_email_notifications boolean DEFAULT true,
    dont_ask_me_for_email boolean DEFAULT false,
    email_last_ask timestamp without time zone,
    dont_ask_me_invite_friends boolean DEFAULT false,
    invite_last_ask timestamp without time zone,
    post_comments boolean DEFAULT true,
    post_likes boolean DEFAULT true,
    post_items boolean DEFAULT true,
    is_blocked boolean DEFAULT false,
    profile_image character varying(255),
    site_id integer
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
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer DEFAULT nextval('users_id_seq'::regclass) NOT NULL,
    ncu_id bigint DEFAULT 0,
    name character varying(255) DEFAULT ''::character varying,
    email character varying(255) DEFAULT ''::character varying,
    is_admin boolean DEFAULT false,
    is_blocked boolean DEFAULT false,
    vote_power integer DEFAULT 1,
    "remoteStatus" character varying(255) DEFAULT 'noverify'::character varying,
    is_member boolean DEFAULT false,
    is_moderator boolean DEFAULT false,
    is_sponsor boolean DEFAULT false,
    is_email_verified boolean DEFAULT false,
    is_researcher boolean DEFAULT false,
    accept_rules boolean DEFAULT false,
    opt_in_study boolean DEFAULT true,
    opt_in_email boolean DEFAULT true,
    opt_in_profile boolean DEFAULT true,
    opt_in_feed boolean DEFAULT true,
    opt_in_sms boolean DEFAULT true,
    created_at timestamp without time zone,
    eligibility character varying(255) DEFAULT 'team'::character varying,
    "cachedPointTotal" integer DEFAULT 0,
    "cachedPointsEarned" integer DEFAULT 0,
    "cachedPointsEarnedThisWeek" integer DEFAULT 0,
    "cachedPointsEarnedLastWeek" integer DEFAULT 0,
    "cachedStoriesPosted" integer DEFAULT 0,
    "cachedCommentsPosted" integer DEFAULT 0,
    "userLevel" character varying(25) DEFAULT 'reader'::character varying,
    login character varying(40),
    crypted_password character varying(40),
    salt character varying(40),
    updated_at timestamp without time zone,
    remember_token character varying(40),
    remember_token_expires_at timestamp without time zone,
    fb_user_id bigint,
    email_hash character varying(255),
    cached_slug character varying(255),
    karma_score integer DEFAULT 0,
    last_active timestamp without time zone,
    is_editor boolean DEFAULT false,
    is_robot boolean DEFAULT false,
    posts_count integer DEFAULT 0,
    last_viewed_feed_item_id integer,
    last_delivered_feed_item_id integer,
    is_host boolean DEFAULT false,
    activity_score integer DEFAULT 0,
    fb_oauth_key character varying(255),
    fb_oauth_denied_at timestamp without time zone,
    twitter_user boolean DEFAULT false,
    system_user boolean DEFAULT false,
    site_id integer
);


--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE videos (
    id integer DEFAULT nextval('videos_id_seq'::regclass) NOT NULL,
    videoable_type character varying(255),
    videoable_id integer,
    user_id integer,
    remote_video_url character varying(255),
    is_blocked boolean DEFAULT false,
    description text,
    embed_code text,
    embed_src character varying(255),
    remote_video_type character varying(255),
    remote_video_id character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    votes_tally integer DEFAULT 0,
    title character varying(255),
    source_id integer,
    thumb_url character varying(255),
    video_processing boolean,
    medium_url character varying(255),
    site_id integer
);


--
-- Name: view_object_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE view_object_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: view_object_templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE view_object_templates (
    id integer DEFAULT nextval('view_object_templates_id_seq'::regclass) NOT NULL,
    template character varying(255),
    name character varying(255),
    pretty_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: view_objects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE view_objects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: view_objects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE view_objects (
    id integer DEFAULT nextval('view_objects_id_seq'::regclass) NOT NULL,
    name character varying(255),
    parent_id integer,
    view_object_template_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: view_tree_edges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE view_tree_edges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: view_tree_edges; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE view_tree_edges (
    id integer DEFAULT nextval('view_tree_edges_id_seq'::regclass) NOT NULL,
    parent_id integer,
    child_id integer,
    "position" integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    site_id integer
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer DEFAULT nextval('votes_id_seq'::regclass) NOT NULL,
    vote boolean DEFAULT false,
    voteable_id integer NOT NULL,
    voteable_type character varying(255) NOT NULL,
    voter_id integer,
    voter_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_blocked boolean DEFAULT false,
    site_id integer
);


--
-- Name: widget_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE widget_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: widget_pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE widget_pages (
    id integer DEFAULT nextval('widget_pages_id_seq'::regclass) NOT NULL,
    widget_id integer,
    parent_id integer,
    widget_type character varying(255),
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "position" character varying(255),
    site_id integer
);


--
-- Name: widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE widgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: widgets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE widgets (
    id integer DEFAULT nextval('widgets_id_seq'::regclass) NOT NULL,
    name character varying(255),
    load_functions character varying(255),
    locals character varying(255),
    partial character varying(255),
    content_type character varying(255),
    metadata text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Name: announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: audios_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audios
    ADD CONSTRAINT audios_pkey PRIMARY KEY (id);


--
-- Name: authentications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY authentications
    ADD CONSTRAINT authentications_pkey PRIMARY KEY (id);


--
-- Name: cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categorizations
    ADD CONSTRAINT categorizations_pkey PRIMARY KEY (id);


--
-- Name: chirps_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY chirps
    ADD CONSTRAINT chirps_pkey PRIMARY KEY (id);


--
-- Name: classifieds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY classifieds
    ADD CONSTRAINT classifieds_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: consumer_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY consumer_tokens
    ADD CONSTRAINT consumer_tokens_pkey PRIMARY KEY (id);


--
-- Name: content_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY content_images
    ADD CONSTRAINT content_images_pkey PRIMARY KEY (id);


--
-- Name: contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contents
    ADD CONSTRAINT contents_pkey PRIMARY KEY (id);


--
-- Name: dashboard_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dashboard_messages
    ADD CONSTRAINT dashboard_messages_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: fbSessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "fbSessions"
    ADD CONSTRAINT "fbSessions_pkey" PRIMARY KEY (id);


--
-- Name: featured_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY featured_items
    ADD CONSTRAINT featured_items_pkey PRIMARY KEY (id);


--
-- Name: feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feeds
    ADD CONSTRAINT feeds_pkey PRIMARY KEY (id);


--
-- Name: flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY flags
    ADD CONSTRAINT flags_pkey PRIMARY KEY (id);


--
-- Name: forums_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forums
    ADD CONSTRAINT forums_pkey PRIMARY KEY (id);


--
-- Name: galleries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY galleries
    ADD CONSTRAINT galleries_pkey PRIMARY KEY (id);


--
-- Name: gallery_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gallery_items
    ADD CONSTRAINT gallery_items_pkey PRIMARY KEY (id);


--
-- Name: gos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gos
    ADD CONSTRAINT gos_pkey PRIMARY KEY (id);


--
-- Name: idea_boards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY idea_boards
    ADD CONSTRAINT idea_boards_pkey PRIMARY KEY (id);


--
-- Name: ideas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ideas
    ADD CONSTRAINT ideas_pkey PRIMARY KEY (id);


--
-- Name: images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: item_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY item_actions
    ADD CONSTRAINT item_actions_pkey PRIMARY KEY (id);


--
-- Name: item_tweets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY item_tweets
    ADD CONSTRAINT item_tweets_pkey PRIMARY KEY (id);


--
-- Name: locales_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locales
    ADD CONSTRAINT locales_pkey PRIMARY KEY (id);


--
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: metadatas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY metadatas
    ADD CONSTRAINT metadatas_pkey PRIMARY KEY (id);


--
-- Name: newswires_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY newswires
    ADD CONSTRAINT newswires_pkey PRIMARY KEY (id);


--
-- Name: pfeed_deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pfeed_deliveries
    ADD CONSTRAINT pfeed_deliveries_pkey PRIMARY KEY (id);


--
-- Name: pfeed_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pfeed_items
    ADD CONSTRAINT pfeed_items_pkey PRIMARY KEY (id);


--
-- Name: prediction_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prediction_groups
    ADD CONSTRAINT prediction_groups_pkey PRIMARY KEY (id);


--
-- Name: prediction_guesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prediction_guesses
    ADD CONSTRAINT prediction_guesses_pkey PRIMARY KEY (id);


--
-- Name: prediction_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prediction_questions
    ADD CONSTRAINT prediction_questions_pkey PRIMARY KEY (id);


--
-- Name: prediction_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prediction_results
    ADD CONSTRAINT prediction_results_pkey PRIMARY KEY (id);


--
-- Name: prediction_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prediction_scores
    ADD CONSTRAINT prediction_scores_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: related_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY related_items
    ADD CONSTRAINT related_items_pkey PRIMARY KEY (id);


--
-- Name: resource_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_sections
    ADD CONSTRAINT resource_sections_pkey PRIMARY KEY (id);


--
-- Name: resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY scores
    ADD CONSTRAINT scores_pkey PRIMARY KEY (id);


--
-- Name: sent_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sent_cards
    ADD CONSTRAINT sent_cards_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY slugs
    ADD CONSTRAINT slugs_pkey PRIMARY KEY (id);


--
-- Name: sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY translations
    ADD CONSTRAINT translations_pkey PRIMARY KEY (id);


--
-- Name: tweet_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tweet_accounts
    ADD CONSTRAINT tweet_accounts_pkey PRIMARY KEY (id);


--
-- Name: tweet_streams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tweet_streams
    ADD CONSTRAINT tweet_streams_pkey PRIMARY KEY (id);


--
-- Name: tweet_urls_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tweet_urls
    ADD CONSTRAINT tweet_urls_pkey PRIMARY KEY (id);


--
-- Name: tweeted_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tweeted_items
    ADD CONSTRAINT tweeted_items_pkey PRIMARY KEY (id);


--
-- Name: tweets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tweets
    ADD CONSTRAINT tweets_pkey PRIMARY KEY (id);


--
-- Name: urls_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY urls
    ADD CONSTRAINT urls_pkey PRIMARY KEY (id);


--
-- Name: user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: view_object_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY view_object_templates
    ADD CONSTRAINT view_object_templates_pkey PRIMARY KEY (id);


--
-- Name: view_objects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY view_objects
    ADD CONSTRAINT view_objects_pkey PRIMARY KEY (id);


--
-- Name: view_tree_edges_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY view_tree_edges
    ADD CONSTRAINT view_tree_edges_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: widget_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY widget_pages
    ADD CONSTRAINT widget_pages_pkey PRIMARY KEY (id);


--
-- Name: widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY widgets
    ADD CONSTRAINT widgets_pkey PRIMARY KEY (id);


--
-- Name: contentid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX contentid ON contents USING btree (contentid);


--
-- Name: feedid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX feedid ON newswires USING btree (feed_id);


--
-- Name: fk_voteables; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk_voteables ON votes USING btree (voteable_id, voteable_type);


--
-- Name: fk_voters; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fk_voters ON votes USING btree (voter_id, voter_type);


--
-- Name: index_answers_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_question_id ON answers USING btree (question_id);


--
-- Name: index_answers_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_answers_on_user_id ON answers USING btree (user_id);


--
-- Name: index_audios_on_audioable_type_and_audioable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_audios_on_audioable_type_and_audioable_id ON audios USING btree (audioable_type, audioable_id);


--
-- Name: index_audios_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_audios_on_user_id ON audios USING btree (user_id);


--
-- Name: index_authentications_on_provider; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authentications_on_provider ON authentications USING btree (provider);


--
-- Name: index_authentications_on_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authentications_on_uid ON authentications USING btree (uid);


--
-- Name: index_authentications_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authentications_on_user_id ON authentications USING btree (user_id);


--
-- Name: index_authentications_on_user_id_and_provider; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_authentications_on_user_id_and_provider ON authentications USING btree (user_id, provider);


--
-- Name: index_categories_on_categorizable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_categorizable_type ON categories USING btree (categorizable_type);


--
-- Name: index_categories_on_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_context ON categories USING btree (context);


--
-- Name: index_categories_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_on_parent_id ON categories USING btree (parent_id);


--
-- Name: index_categorizations_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categorizations_on_category_id ON categorizations USING btree (category_id);


--
-- Name: index_classifieds_on_aasm_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_classifieds_on_aasm_state ON classifieds USING btree (aasm_state);


--
-- Name: index_classifieds_on_allow; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_classifieds_on_allow ON classifieds USING btree (allow);


--
-- Name: index_classifieds_on_expires_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_classifieds_on_expires_at ON classifieds USING btree (expires_at);


--
-- Name: index_classifieds_on_listing_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_classifieds_on_listing_type ON classifieds USING btree (listing_type);


--
-- Name: index_classifieds_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_classifieds_on_user_id ON classifieds USING btree (user_id);


--
-- Name: index_comments_on_commentable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_type ON comments USING btree (commentable_type);


--
-- Name: index_comments_on_commentable_type_and_commentable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_type_and_commentable_id ON comments USING btree (commentable_type, commentable_id);


--
-- Name: index_consumer_tokens_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_consumer_tokens_on_user_id ON consumer_tokens USING btree (user_id);


--
-- Name: index_content_images_on_content_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_content_images_on_content_id ON content_images USING btree (content_id);


--
-- Name: index_contents_on_story_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_contents_on_story_type ON contents USING btree (story_type);


--
-- Name: index_events_on_eid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_eid ON events USING btree (eid);


--
-- Name: index_featured_items_on_featurable_type_and_featurable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_featured_items_on_featurable_type_and_featurable_id ON featured_items USING btree (featurable_type, featurable_id);


--
-- Name: index_featured_items_on_featured_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_featured_items_on_featured_type ON featured_items USING btree (featured_type);


--
-- Name: index_featured_items_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_featured_items_on_name ON featured_items USING btree (name);


--
-- Name: index_featured_items_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_featured_items_on_parent_id ON featured_items USING btree (parent_id);


--
-- Name: index_feeds_on_deleted_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feeds_on_deleted_at ON feeds USING btree (deleted_at);


--
-- Name: index_feeds_on_enabled; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_feeds_on_enabled ON feeds USING btree (enabled);


--
-- Name: index_flags_on_flaggable_type_and_flaggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_flags_on_flaggable_type_and_flaggable_id ON flags USING btree (flaggable_type, flaggable_id);


--
-- Name: index_galleries_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_galleries_on_title ON galleries USING btree (title);


--
-- Name: index_galleries_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_galleries_on_user_id ON galleries USING btree (user_id);


--
-- Name: index_gallery_items_on_cached_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gallery_items_on_cached_slug ON gallery_items USING btree (cached_slug);


--
-- Name: index_gallery_items_on_gallery_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gallery_items_on_gallery_id ON gallery_items USING btree (gallery_id);


--
-- Name: index_gallery_items_on_galleryable_type_and_galleryable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gallery_items_on_galleryable_type_and_galleryable_id ON gallery_items USING btree (galleryable_type, galleryable_id);


--
-- Name: index_gallery_items_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gallery_items_on_title ON gallery_items USING btree (title);


--
-- Name: index_gallery_items_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gallery_items_on_user_id ON gallery_items USING btree (user_id);


--
-- Name: index_gos_on_cached_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gos_on_cached_slug ON gos USING btree (cached_slug);


--
-- Name: index_gos_on_goable_type_and_goable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gos_on_goable_type_and_goable_id ON gos USING btree (goable_type, goable_id);


--
-- Name: index_gos_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gos_on_name ON gos USING btree (name);


--
-- Name: index_gos_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_gos_on_user_id ON gos USING btree (user_id);


--
-- Name: index_images_on_imageable_type_and_imageable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_images_on_imageable_type_and_imageable_id ON images USING btree (imageable_type, imageable_id);


--
-- Name: index_images_on_remote_image_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_images_on_remote_image_url ON images USING btree (remote_image_url);


--
-- Name: index_images_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_images_on_user_id ON images USING btree (user_id);


--
-- Name: index_item_actions_on_action_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_item_actions_on_action_type ON item_actions USING btree (action_type);


--
-- Name: index_item_actions_on_actionable_type_and_actionable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_item_actions_on_actionable_type_and_actionable_id ON item_actions USING btree (actionable_type, actionable_id);


--
-- Name: index_item_actions_on_is_blocked; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_item_actions_on_is_blocked ON item_actions USING btree (is_blocked);


--
-- Name: index_item_actions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_item_actions_on_user_id ON item_actions USING btree (user_id);


--
-- Name: index_item_tweets_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_item_tweets_on_item_type_and_item_id ON item_tweets USING btree (item_type, item_id);


--
-- Name: index_item_tweets_on_tweet_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_item_tweets_on_tweet_id ON item_tweets USING btree (tweet_id);


--
-- Name: index_locales_on_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_locales_on_code ON locales USING btree (code);


--
-- Name: index_metadatas_on_key_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadatas_on_key_name ON metadatas USING btree (key_name);


--
-- Name: index_metadatas_on_key_type_and_key_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadatas_on_key_type_and_key_name ON metadatas USING btree (key_type, key_name);


--
-- Name: index_metadatas_on_key_type_and_key_sub_type_and_key_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadatas_on_key_type_and_key_sub_type_and_key_name ON metadatas USING btree (key_type, key_sub_type, key_name);


--
-- Name: index_metadatas_on_metadatable_type_and_metadatable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_metadatas_on_metadatable_type_and_metadatable_id ON metadatas USING btree (metadatable_type, metadatable_id);


--
-- Name: index_newswires_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_newswires_on_title ON newswires USING btree (title);


--
-- Name: index_questions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_user_id ON questions USING btree (user_id);


--
-- Name: index_scores_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_scores_on_created_at ON scores USING btree (created_at);


--
-- Name: index_scores_on_scorable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_scores_on_scorable_type ON scores USING btree (scorable_type);


--
-- Name: index_scores_on_scorable_type_and_scorable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_scores_on_scorable_type_and_scorable_id ON scores USING btree (scorable_type, scorable_id);


--
-- Name: index_scores_on_score_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_scores_on_score_type ON scores USING btree (score_type);


--
-- Name: index_scores_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_scores_on_user_id ON scores USING btree (user_id);


--
-- Name: index_sent_cards_on_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sent_cards_on_card_id ON sent_cards USING btree (card_id);


--
-- Name: index_sent_cards_on_from_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sent_cards_on_from_user_id ON sent_cards USING btree (from_user_id);


--
-- Name: index_sent_cards_on_from_user_id_and_card_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sent_cards_on_from_user_id_and_card_id ON sent_cards USING btree (from_user_id, card_id);


--
-- Name: index_sent_cards_on_from_user_id_and_card_id_and_to_fb_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sent_cards_on_from_user_id_and_card_id_and_to_fb_user_id ON sent_cards USING btree (from_user_id, card_id, to_fb_user_id);


--
-- Name: index_sent_cards_on_to_fb_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sent_cards_on_to_fb_user_id ON sent_cards USING btree (to_fb_user_id);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_session_id ON sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sessions_on_updated_at ON sessions USING btree (updated_at);


--
-- Name: index_slugs_on_n_s_s_and_s; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_slugs_on_n_s_s_and_s ON slugs USING btree (name, sluggable_type, scope, sequence);


--
-- Name: index_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_slugs_on_sluggable_id ON slugs USING btree (sluggable_id);


--
-- Name: index_sources_on_black_list; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sources_on_black_list ON sources USING btree (black_list);


--
-- Name: index_sources_on_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_sources_on_url ON sources USING btree (url);


--
-- Name: index_sources_on_white_list; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sources_on_white_list ON sources USING btree (white_list);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_topics_on_forum_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_topics_on_forum_id ON topics USING btree (forum_id);


--
-- Name: index_topics_on_forum_id_and_replied_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_topics_on_forum_id_and_replied_at ON topics USING btree (forum_id, replied_at);


--
-- Name: index_topics_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_topics_on_user_id ON topics USING btree (user_id);


--
-- Name: index_translations_on_locale_id_and_key_and_pluralization_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_translations_on_locale_id_and_key_and_pluralization_index ON translations USING btree (locale_id, key, pluralization_index);


--
-- Name: index_tweet_accounts_on_screen_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tweet_accounts_on_screen_name ON tweet_accounts USING btree (screen_name);


--
-- Name: index_tweet_accounts_on_twitter_id_str; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tweet_accounts_on_twitter_id_str ON tweet_accounts USING btree (twitter_id_str);


--
-- Name: index_tweet_accounts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tweet_accounts_on_user_id ON tweet_accounts USING btree (user_id);


--
-- Name: index_tweet_streams_on_is_blocked; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tweet_streams_on_is_blocked ON tweet_streams USING btree (is_blocked);


--
-- Name: index_tweet_streams_on_list_username_and_list_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tweet_streams_on_list_username_and_list_name ON tweet_streams USING btree (list_username, list_name);


--
-- Name: index_tweet_streams_on_twitter_id_str; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tweet_streams_on_twitter_id_str ON tweet_streams USING btree (twitter_id_str);


--
-- Name: index_tweet_urls_on_tweet_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tweet_urls_on_tweet_id ON tweet_urls USING btree (tweet_id);


--
-- Name: index_tweet_urls_on_tweet_id_and_url_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tweet_urls_on_tweet_id_and_url_id ON tweet_urls USING btree (tweet_id, url_id);


--
-- Name: index_tweet_urls_on_url_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tweet_urls_on_url_id ON tweet_urls USING btree (url_id);


--
-- Name: index_tweets_on_tweet_stream_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tweets_on_tweet_stream_id ON tweets USING btree (tweet_stream_id);


--
-- Name: index_tweets_on_twitter_id_str; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tweets_on_twitter_id_str ON tweets USING btree (twitter_id_str);


--
-- Name: index_urls_on_source_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_urls_on_source_id ON urls USING btree (source_id);


--
-- Name: index_urls_on_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_urls_on_url ON urls USING btree (url);


--
-- Name: index_user_infos_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_user_infos_on_user_id ON user_profiles USING btree (user_id);


--
-- Name: index_users_on_login; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_login ON users USING btree (login);


--
-- Name: index_users_on_posts_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_posts_count ON users USING btree (posts_count);


--
-- Name: index_users_on_system_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_system_user ON users USING btree (system_user);


--
-- Name: index_users_on_twitter_user; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_twitter_user ON users USING btree (twitter_user);


--
-- Name: index_videos_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_videos_on_user_id ON videos USING btree (user_id);


--
-- Name: index_videos_on_videoable_type_and_videoable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_videos_on_videoable_type_and_videoable_id ON videos USING btree (videoable_type, videoable_id);


--
-- Name: index_view_object_templates_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_view_object_templates_on_name ON view_object_templates USING btree (name);


--
-- Name: index_view_tree_edges_on_child_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_view_tree_edges_on_child_id ON view_tree_edges USING btree (child_id);


--
-- Name: index_view_tree_edges_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_view_tree_edges_on_parent_id ON view_tree_edges USING btree (parent_id);


--
-- Name: index_widget_pages_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_widget_pages_on_name ON widget_pages USING btree (name);


--
-- Name: index_widget_pages_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_widget_pages_on_parent_id ON widget_pages USING btree (parent_id);


--
-- Name: index_widget_pages_on_widget_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_widget_pages_on_widget_id ON widget_pages USING btree (widget_id);


--
-- Name: index_widget_pages_on_widget_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_widget_pages_on_widget_type ON widget_pages USING btree (widget_type);


--
-- Name: index_widgets_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_widgets_on_name ON widgets USING btree (name);


--
-- Name: related; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX related ON questions USING btree (question);


--
-- Name: relatedItems; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "relatedItems" ON contents USING btree (title);


--
-- Name: relatedText; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "relatedText" ON contents USING btree (title);


--
-- Name: siteContentId; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "siteContentId" ON content_images USING btree (content_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20091124161003');

INSERT INTO schema_migrations (version) VALUES ('20091124162312');

INSERT INTO schema_migrations (version) VALUES ('20091124182343');

INSERT INTO schema_migrations (version) VALUES ('20091124190738');

INSERT INTO schema_migrations (version) VALUES ('20091124204325');

INSERT INTO schema_migrations (version) VALUES ('20091124231957');

INSERT INTO schema_migrations (version) VALUES ('20091201224354');

INSERT INTO schema_migrations (version) VALUES ('20091202012039');

INSERT INTO schema_migrations (version) VALUES ('20091202064956');

INSERT INTO schema_migrations (version) VALUES ('20091203014546');

INSERT INTO schema_migrations (version) VALUES ('20091203204959');

INSERT INTO schema_migrations (version) VALUES ('20091203210908');

INSERT INTO schema_migrations (version) VALUES ('20091208012226');

INSERT INTO schema_migrations (version) VALUES ('20091208013109');

INSERT INTO schema_migrations (version) VALUES ('20091222010834');

INSERT INTO schema_migrations (version) VALUES ('20100103205822');

INSERT INTO schema_migrations (version) VALUES ('20100103215300');

INSERT INTO schema_migrations (version) VALUES ('20100103220246');

INSERT INTO schema_migrations (version) VALUES ('20100103220337');

INSERT INTO schema_migrations (version) VALUES ('20100107182956');

INSERT INTO schema_migrations (version) VALUES ('20100109003023');

INSERT INTO schema_migrations (version) VALUES ('20100111222056');

INSERT INTO schema_migrations (version) VALUES ('20100113182120');

INSERT INTO schema_migrations (version) VALUES ('20100114002308');

INSERT INTO schema_migrations (version) VALUES ('20100115011425');

INSERT INTO schema_migrations (version) VALUES ('20100118233030');

INSERT INTO schema_migrations (version) VALUES ('20100120001612');

INSERT INTO schema_migrations (version) VALUES ('20100121193612');

INSERT INTO schema_migrations (version) VALUES ('20100122011348');

INSERT INTO schema_migrations (version) VALUES ('20100204221559');

INSERT INTO schema_migrations (version) VALUES ('20100204232503');

INSERT INTO schema_migrations (version) VALUES ('20100204233243');

INSERT INTO schema_migrations (version) VALUES ('20100205014711');

INSERT INTO schema_migrations (version) VALUES ('20100205015017');

INSERT INTO schema_migrations (version) VALUES ('20100205015709');

INSERT INTO schema_migrations (version) VALUES ('20100211002808');

INSERT INTO schema_migrations (version) VALUES ('20100211013650');

INSERT INTO schema_migrations (version) VALUES ('20100211072609');

INSERT INTO schema_migrations (version) VALUES ('20100212003651');

INSERT INTO schema_migrations (version) VALUES ('20100212014901');

INSERT INTO schema_migrations (version) VALUES ('20100212220024');

INSERT INTO schema_migrations (version) VALUES ('20100212220146');

INSERT INTO schema_migrations (version) VALUES ('20100213221244');

INSERT INTO schema_migrations (version) VALUES ('20100215214122');

INSERT INTO schema_migrations (version) VALUES ('20100215224032');

INSERT INTO schema_migrations (version) VALUES ('20100216031801');

INSERT INTO schema_migrations (version) VALUES ('20100217011121');

INSERT INTO schema_migrations (version) VALUES ('20100217021117');

INSERT INTO schema_migrations (version) VALUES ('20100227021124');

INSERT INTO schema_migrations (version) VALUES ('20100227190146');

INSERT INTO schema_migrations (version) VALUES ('20100227190653');

INSERT INTO schema_migrations (version) VALUES ('20100302203538');

INSERT INTO schema_migrations (version) VALUES ('20100303014650');

INSERT INTO schema_migrations (version) VALUES ('20100303202402');

INSERT INTO schema_migrations (version) VALUES ('20100305005027');

INSERT INTO schema_migrations (version) VALUES ('20100309162706');

INSERT INTO schema_migrations (version) VALUES ('20100315185556');

INSERT INTO schema_migrations (version) VALUES ('20100315230605');

INSERT INTO schema_migrations (version) VALUES ('20100317083752');

INSERT INTO schema_migrations (version) VALUES ('20100323193005');

INSERT INTO schema_migrations (version) VALUES ('20100326220707');

INSERT INTO schema_migrations (version) VALUES ('20100405201921');

INSERT INTO schema_migrations (version) VALUES ('20100414191921');

INSERT INTO schema_migrations (version) VALUES ('20100419192519');

INSERT INTO schema_migrations (version) VALUES ('20100420011145');

INSERT INTO schema_migrations (version) VALUES ('20100507001639');

INSERT INTO schema_migrations (version) VALUES ('20100513191243');

INSERT INTO schema_migrations (version) VALUES ('20100513204141');

INSERT INTO schema_migrations (version) VALUES ('20100513220901');

INSERT INTO schema_migrations (version) VALUES ('20100516002048');

INSERT INTO schema_migrations (version) VALUES ('20100519173310');

INSERT INTO schema_migrations (version) VALUES ('20100519205155');

INSERT INTO schema_migrations (version) VALUES ('20100519211150');

INSERT INTO schema_migrations (version) VALUES ('20100519223249');

INSERT INTO schema_migrations (version) VALUES ('20100520224828');

INSERT INTO schema_migrations (version) VALUES ('20100521205635');

INSERT INTO schema_migrations (version) VALUES ('20100524231011');

INSERT INTO schema_migrations (version) VALUES ('20100526231658');

INSERT INTO schema_migrations (version) VALUES ('20100608230348');

INSERT INTO schema_migrations (version) VALUES ('20100609180615');

INSERT INTO schema_migrations (version) VALUES ('20100609190538');

INSERT INTO schema_migrations (version) VALUES ('20100609190539');

INSERT INTO schema_migrations (version) VALUES ('20100611200848');

INSERT INTO schema_migrations (version) VALUES ('20100615220810');

INSERT INTO schema_migrations (version) VALUES ('20100623230028');

INSERT INTO schema_migrations (version) VALUES ('20100624005830');

INSERT INTO schema_migrations (version) VALUES ('20100629184103');

INSERT INTO schema_migrations (version) VALUES ('20100629184323');

INSERT INTO schema_migrations (version) VALUES ('20100629204741');

INSERT INTO schema_migrations (version) VALUES ('20100630164852');

INSERT INTO schema_migrations (version) VALUES ('20100630222126');

INSERT INTO schema_migrations (version) VALUES ('20100707181429');

INSERT INTO schema_migrations (version) VALUES ('20100709215511');

INSERT INTO schema_migrations (version) VALUES ('20100712194600');

INSERT INTO schema_migrations (version) VALUES ('20100712201622');

INSERT INTO schema_migrations (version) VALUES ('20100715010547');

INSERT INTO schema_migrations (version) VALUES ('20100715214727');

INSERT INTO schema_migrations (version) VALUES ('20100719210642');

INSERT INTO schema_migrations (version) VALUES ('20100725185136');

INSERT INTO schema_migrations (version) VALUES ('20100725185233');

INSERT INTO schema_migrations (version) VALUES ('20100725185245');

INSERT INTO schema_migrations (version) VALUES ('20100725185301');

INSERT INTO schema_migrations (version) VALUES ('20100729204126');

INSERT INTO schema_migrations (version) VALUES ('20100730233038');

INSERT INTO schema_migrations (version) VALUES ('20100731065950');

INSERT INTO schema_migrations (version) VALUES ('20100801015214');

INSERT INTO schema_migrations (version) VALUES ('20100811214903');

INSERT INTO schema_migrations (version) VALUES ('20100823172428');

INSERT INTO schema_migrations (version) VALUES ('20100823173716');

INSERT INTO schema_migrations (version) VALUES ('20100823190356');

INSERT INTO schema_migrations (version) VALUES ('20100826201801');

INSERT INTO schema_migrations (version) VALUES ('20100907214306');

INSERT INTO schema_migrations (version) VALUES ('20100915230718');

INSERT INTO schema_migrations (version) VALUES ('20101025174437');

INSERT INTO schema_migrations (version) VALUES ('20101025175337');

INSERT INTO schema_migrations (version) VALUES ('20101027210642');

INSERT INTO schema_migrations (version) VALUES ('20101027210809');

INSERT INTO schema_migrations (version) VALUES ('20101109205202');

INSERT INTO schema_migrations (version) VALUES ('20101216230321');

INSERT INTO schema_migrations (version) VALUES ('20101218000625');

INSERT INTO schema_migrations (version) VALUES ('20101221232829');

INSERT INTO schema_migrations (version) VALUES ('20101223190321');

INSERT INTO schema_migrations (version) VALUES ('20101223233329');

INSERT INTO schema_migrations (version) VALUES ('20110107194323');

INSERT INTO schema_migrations (version) VALUES ('20110114011317');

INSERT INTO schema_migrations (version) VALUES ('20110122012647');

INSERT INTO schema_migrations (version) VALUES ('20110202235232');

INSERT INTO schema_migrations (version) VALUES ('20110204222901');

INSERT INTO schema_migrations (version) VALUES ('20110209013341');

INSERT INTO schema_migrations (version) VALUES ('20110209184821');

INSERT INTO schema_migrations (version) VALUES ('20110301231641');

INSERT INTO schema_migrations (version) VALUES ('20110302011840');

INSERT INTO schema_migrations (version) VALUES ('20110309212528');

INSERT INTO schema_migrations (version) VALUES ('20110324193416');

INSERT INTO schema_migrations (version) VALUES ('20110405193504');

INSERT INTO schema_migrations (version) VALUES ('20110525165455');

INSERT INTO schema_migrations (version) VALUES ('20110531181259');

INSERT INTO schema_migrations (version) VALUES ('20110603181934');

INSERT INTO schema_migrations (version) VALUES ('20110627220941');

INSERT INTO schema_migrations (version) VALUES ('20110811204937');

INSERT INTO schema_migrations (version) VALUES ('20110811232456');

INSERT INTO schema_migrations (version) VALUES ('20110812002233');

INSERT INTO schema_migrations (version) VALUES ('20110815184455');

INSERT INTO schema_migrations (version) VALUES ('20110817211627');

INSERT INTO schema_migrations (version) VALUES ('20110818235255');

INSERT INTO schema_migrations (version) VALUES ('20110823205401');

INSERT INTO schema_migrations (version) VALUES ('20110829232116');

INSERT INTO schema_migrations (version) VALUES ('20110908222555');

INSERT INTO schema_migrations (version) VALUES ('20110916233249');

INSERT INTO schema_migrations (version) VALUES ('20111005215423');

INSERT INTO schema_migrations (version) VALUES ('20111012215608');

INSERT INTO schema_migrations (version) VALUES ('20111018212247');

INSERT INTO schema_migrations (version) VALUES ('20111026003847');

INSERT INTO schema_migrations (version) VALUES ('20111213194038');