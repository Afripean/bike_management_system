PGDMP  +    $                |            innovation_project    14.11    16.2 J    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    76315    innovation_project    DATABASE     �   CREATE DATABASE innovation_project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Chinese (Simplified)_China.936';
 "   DROP DATABASE innovation_project;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    5                        3079    76525    postgis 	   EXTENSION     ;   CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
    DROP EXTENSION postgis;
                   false    5            �           0    0    EXTENSION postgis    COMMENT     ^   COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';
                        false    2            r           1247    77618    vehicle_status    TYPE     `   CREATE TYPE public.vehicle_status AS ENUM (
    'available',
    'in_use',
    'maintenance'
);
 !   DROP TYPE public.vehicle_status;
       public          postgres    false    5            �           1255    77681 J   random_timestamp(timestamp without time zone, timestamp without time zone)    FUNCTION     D  CREATE FUNCTION public.random_timestamp(start_date timestamp without time zone, end_date timestamp without time zone) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN start_date + (RANDOM() * (EXTRACT(EPOCH FROM end_date) - EXTRACT(EPOCH FROM start_date))) * INTERVAL '1 second';
END;
$$;
 u   DROP FUNCTION public.random_timestamp(start_date timestamp without time zone, end_date timestamp without time zone);
       public          postgres    false    5            �           1255    77678    update_parking_areas_function()    FUNCTION     �   CREATE FUNCTION public.update_parking_areas_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE ParkingAreas
    SET areaId = NEW.che_area
    WHERE areaId = OLD.che_area;
    RETURN NEW;
END;
$$;
 6   DROP FUNCTION public.update_parking_areas_function();
       public          postgres    false    5            �            1259    77658    carbonanalysis    TABLE       CREATE TABLE public.carbonanalysis (
    analysisid integer NOT NULL,
    userid bigint NOT NULL,
    totaldistance numeric(10,2) NOT NULL,
    carbonsaved numeric(10,2) NOT NULL,
    analysisdate date NOT NULL,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 "   DROP TABLE public.carbonanalysis;
       public         heap    postgres    false    5            �            1259    77657    carbonanalysis_analysisid_seq    SEQUENCE     �   CREATE SEQUENCE public.carbonanalysis_analysisid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.carbonanalysis_analysisid_seq;
       public          postgres    false    230    5            �           0    0    carbonanalysis_analysisid_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.carbonanalysis_analysisid_seq OWNED BY public.carbonanalysis.analysisid;
          public          postgres    false    229            �            1259    77608    parkingareas    TABLE     �   CREATE TABLE public.parkingareas (
    areaid integer NOT NULL,
    areaname character varying(100) NOT NULL,
    area public.geometry NOT NULL,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
     DROP TABLE public.parkingareas;
       public         heap    postgres    false    5    2    2    5    2    5    2    5    2    5    2    5    2    5    2    5    5            �            1259    77607    parkingareas_areaid_seq    SEQUENCE     �   CREATE SEQUENCE public.parkingareas_areaid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.parkingareas_areaid_seq;
       public          postgres    false    5    224            �           0    0    parkingareas_areaid_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.parkingareas_areaid_seq OWNED BY public.parkingareas.areaid;
          public          postgres    false    223            �            1259    76505    t_che    TABLE     �  CREATE TABLE public.t_che (
    id bigint NOT NULL,
    che_name character varying(50) NOT NULL,
    che_area character varying(50) NOT NULL,
    che_date character varying(50) NOT NULL,
    che_ren character varying(50) NOT NULL,
    che_phone character varying(50) NOT NULL,
    che_type character varying(50) NOT NULL,
    che_wei character varying(50) NOT NULL,
    che_status character varying(50) NOT NULL,
    che_text character varying(50) NOT NULL
);
    DROP TABLE public.t_che;
       public         heap    postgres    false    5            �            1259    76504    t_che_id_seq    SEQUENCE     u   CREATE SEQUENCE public.t_che_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.t_che_id_seq;
       public          postgres    false    213    5            �           0    0    t_che_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.t_che_id_seq OWNED BY public.t_che.id;
          public          postgres    false    212            �            1259    76519    t_notice    TABLE     �   CREATE TABLE public.t_notice (
    id bigint NOT NULL,
    notice_name character varying(50) NOT NULL,
    notice_text character varying(200) NOT NULL,
    notice_type character varying(50) NOT NULL,
    create_date character varying(50) NOT NULL
);
    DROP TABLE public.t_notice;
       public         heap    postgres    false    5            �            1259    76518    t_notice_id_seq    SEQUENCE     x   CREATE SEQUENCE public.t_notice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.t_notice_id_seq;
       public          postgres    false    5    217            �           0    0    t_notice_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.t_notice_id_seq OWNED BY public.t_notice.id;
          public          postgres    false    216            �            1259    76498    t_user    TABLE     J  CREATE TABLE public.t_user (
    id bigint NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    real_name character varying(50),
    user_sex character varying(50),
    user_phone character varying(50),
    user_text character varying(50),
    user_type character varying(50)
);
    DROP TABLE public.t_user;
       public         heap    postgres    false    5            �            1259    76497    t_user_id_seq    SEQUENCE     v   CREATE SEQUENCE public.t_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.t_user_id_seq;
       public          postgres    false    5    211            �           0    0    t_user_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.t_user_id_seq OWNED BY public.t_user.id;
          public          postgres    false    210            �            1259    76512    t_xiu    TABLE     �  CREATE TABLE public.t_xiu (
    id bigint NOT NULL,
    xiu_name character varying(50) NOT NULL,
    xiu_reason character varying(50) NOT NULL,
    xiu_date character varying(50) NOT NULL,
    xiu_handledate character varying(50) NOT NULL,
    xiu_ren character varying(50) NOT NULL,
    xiu_phone character varying(50) NOT NULL,
    xiu_status character varying(50) NOT NULL,
    xiu_text character varying(50) NOT NULL
);
    DROP TABLE public.t_xiu;
       public         heap    postgres    false    5            �            1259    76511    t_xiu_id_seq    SEQUENCE     u   CREATE SEQUENCE public.t_xiu_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.t_xiu_id_seq;
       public          postgres    false    215    5            �           0    0    t_xiu_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.t_xiu_id_seq OWNED BY public.t_xiu.id;
          public          postgres    false    214            �            1259    77638    travelpaths    TABLE     k  CREATE TABLE public.travelpaths (
    pathid integer NOT NULL,
    userid bigint NOT NULL,
    vehicleid integer NOT NULL,
    starttime timestamp without time zone NOT NULL,
    endtime timestamp without time zone,
    pathdata public.geometry NOT NULL,
    distance numeric(10,2) NOT NULL,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.travelpaths;
       public         heap    postgres    false    5    2    2    5    2    5    2    5    2    5    2    5    2    5    2    5    5            �            1259    77637    travelpaths_pathid_seq    SEQUENCE     �   CREATE SEQUENCE public.travelpaths_pathid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.travelpaths_pathid_seq;
       public          postgres    false    228    5            �           0    0    travelpaths_pathid_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.travelpaths_pathid_seq OWNED BY public.travelpaths.pathid;
          public          postgres    false    227            �            1259    77626    vehicles    TABLE     �  CREATE TABLE public.vehicles (
    vehicleid integer NOT NULL,
    licenseplate character varying(20) NOT NULL,
    type character varying(50) NOT NULL,
    status public.vehicle_status NOT NULL,
    che_date character varying(50) NOT NULL,
    che_ren character varying(50) NOT NULL,
    che_phone character varying(50) NOT NULL,
    location public.geometry,
    lastmaintenancedate date,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    che_area integer
);
    DROP TABLE public.vehicles;
       public         heap    postgres    false    2    2    5    2    5    2    5    2    5    2    5    2    5    2    5    5    5    1650            �            1259    77625    vehicles_vehicleid_seq    SEQUENCE     �   CREATE SEQUENCE public.vehicles_vehicleid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.vehicles_vehicleid_seq;
       public          postgres    false    5    226            �           0    0    vehicles_vehicleid_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.vehicles_vehicleid_seq OWNED BY public.vehicles.vehicleid;
          public          postgres    false    225            *           2604    77661    carbonanalysis analysisid    DEFAULT     �   ALTER TABLE ONLY public.carbonanalysis ALTER COLUMN analysisid SET DEFAULT nextval('public.carbonanalysis_analysisid_seq'::regclass);
 H   ALTER TABLE public.carbonanalysis ALTER COLUMN analysisid DROP DEFAULT;
       public          postgres    false    230    229    230            $           2604    77611    parkingareas areaid    DEFAULT     z   ALTER TABLE ONLY public.parkingareas ALTER COLUMN areaid SET DEFAULT nextval('public.parkingareas_areaid_seq'::regclass);
 B   ALTER TABLE public.parkingareas ALTER COLUMN areaid DROP DEFAULT;
       public          postgres    false    224    223    224            !           2604    76508    t_che id    DEFAULT     d   ALTER TABLE ONLY public.t_che ALTER COLUMN id SET DEFAULT nextval('public.t_che_id_seq'::regclass);
 7   ALTER TABLE public.t_che ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    212    213    213            #           2604    76522    t_notice id    DEFAULT     j   ALTER TABLE ONLY public.t_notice ALTER COLUMN id SET DEFAULT nextval('public.t_notice_id_seq'::regclass);
 :   ALTER TABLE public.t_notice ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    217    217                        2604    76501 	   t_user id    DEFAULT     f   ALTER TABLE ONLY public.t_user ALTER COLUMN id SET DEFAULT nextval('public.t_user_id_seq'::regclass);
 8   ALTER TABLE public.t_user ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    211    211            "           2604    76515    t_xiu id    DEFAULT     d   ALTER TABLE ONLY public.t_xiu ALTER COLUMN id SET DEFAULT nextval('public.t_xiu_id_seq'::regclass);
 7   ALTER TABLE public.t_xiu ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    214    215    215            (           2604    77641    travelpaths pathid    DEFAULT     x   ALTER TABLE ONLY public.travelpaths ALTER COLUMN pathid SET DEFAULT nextval('public.travelpaths_pathid_seq'::regclass);
 A   ALTER TABLE public.travelpaths ALTER COLUMN pathid DROP DEFAULT;
       public          postgres    false    228    227    228            &           2604    77629    vehicles vehicleid    DEFAULT     x   ALTER TABLE ONLY public.vehicles ALTER COLUMN vehicleid SET DEFAULT nextval('public.vehicles_vehicleid_seq'::regclass);
 A   ALTER TABLE public.vehicles ALTER COLUMN vehicleid DROP DEFAULT;
       public          postgres    false    225    226    226            �          0    77658    carbonanalysis 
   TABLE DATA           q   COPY public.carbonanalysis (analysisid, userid, totaldistance, carbonsaved, analysisdate, createdat) FROM stdin;
    public          postgres    false    230   \       �          0    77608    parkingareas 
   TABLE DATA           I   COPY public.parkingareas (areaid, areaname, area, createdat) FROM stdin;
    public          postgres    false    224   -\                 0    76842    spatial_ref_sys 
   TABLE DATA           X   COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
    public          postgres    false    219   �^       �          0    76505    t_che 
   TABLE DATA           ~   COPY public.t_che (id, che_name, che_area, che_date, che_ren, che_phone, che_type, che_wei, che_status, che_text) FROM stdin;
    public          postgres    false    213   �^       �          0    76519    t_notice 
   TABLE DATA           Z   COPY public.t_notice (id, notice_name, notice_text, notice_type, create_date) FROM stdin;
    public          postgres    false    217   0_       �          0    76498    t_user 
   TABLE DATA           o   COPY public.t_user (id, username, password, real_name, user_sex, user_phone, user_text, user_type) FROM stdin;
    public          postgres    false    211   �a       �          0    76512    t_xiu 
   TABLE DATA           }   COPY public.t_xiu (id, xiu_name, xiu_reason, xiu_date, xiu_handledate, xiu_ren, xiu_phone, xiu_status, xiu_text) FROM stdin;
    public          postgres    false    215   Ab       �          0    77638    travelpaths 
   TABLE DATA           s   COPY public.travelpaths (pathid, userid, vehicleid, starttime, endtime, pathdata, distance, createdat) FROM stdin;
    public          postgres    false    228   ^b       �          0    77626    vehicles 
   TABLE DATA           �   COPY public.vehicles (vehicleid, licenseplate, type, status, che_date, che_ren, che_phone, location, lastmaintenancedate, createdat, che_area) FROM stdin;
    public          postgres    false    226   p       �           0    0    carbonanalysis_analysisid_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.carbonanalysis_analysisid_seq', 1, false);
          public          postgres    false    229            �           0    0    parkingareas_areaid_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.parkingareas_areaid_seq', 26, true);
          public          postgres    false    223            �           0    0    t_che_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.t_che_id_seq', 1, true);
          public          postgres    false    212            �           0    0    t_notice_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.t_notice_id_seq', 20, true);
          public          postgres    false    216            �           0    0    t_user_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.t_user_id_seq', 9, true);
          public          postgres    false    210            �           0    0    t_xiu_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.t_xiu_id_seq', 1, false);
          public          postgres    false    214            �           0    0    travelpaths_pathid_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.travelpaths_pathid_seq', 54, true);
          public          postgres    false    227            �           0    0    vehicles_vehicleid_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.vehicles_vehicleid_seq', 53, true);
          public          postgres    false    225            @           2606    77664 "   carbonanalysis carbonanalysis_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.carbonanalysis
    ADD CONSTRAINT carbonanalysis_pkey PRIMARY KEY (analysisid);
 L   ALTER TABLE ONLY public.carbonanalysis DROP CONSTRAINT carbonanalysis_pkey;
       public            postgres    false    230            8           2606    77616    parkingareas parkingareas_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.parkingareas
    ADD CONSTRAINT parkingareas_pkey PRIMARY KEY (areaid);
 H   ALTER TABLE ONLY public.parkingareas DROP CONSTRAINT parkingareas_pkey;
       public            postgres    false    224            0           2606    76510    t_che t_che_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.t_che
    ADD CONSTRAINT t_che_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.t_che DROP CONSTRAINT t_che_pkey;
       public            postgres    false    213            4           2606    76524    t_notice t_notice_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.t_notice
    ADD CONSTRAINT t_notice_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.t_notice DROP CONSTRAINT t_notice_pkey;
       public            postgres    false    217            .           2606    76503    t_user t_user_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.t_user
    ADD CONSTRAINT t_user_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.t_user DROP CONSTRAINT t_user_pkey;
       public            postgres    false    211            2           2606    76517    t_xiu t_xiu_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.t_xiu
    ADD CONSTRAINT t_xiu_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.t_xiu DROP CONSTRAINT t_xiu_pkey;
       public            postgres    false    215            >           2606    77646    travelpaths travelpaths_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.travelpaths
    ADD CONSTRAINT travelpaths_pkey PRIMARY KEY (pathid);
 F   ALTER TABLE ONLY public.travelpaths DROP CONSTRAINT travelpaths_pkey;
       public            postgres    false    228            :           2606    77636 "   vehicles vehicles_licenseplate_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_licenseplate_key UNIQUE (licenseplate);
 L   ALTER TABLE ONLY public.vehicles DROP CONSTRAINT vehicles_licenseplate_key;
       public            postgres    false    226            <           2606    77634    vehicles vehicles_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (vehicleid);
 @   ALTER TABLE ONLY public.vehicles DROP CONSTRAINT vehicles_pkey;
       public            postgres    false    226            E           2620    77679 %   vehicles update_parking_areas_trigger    TRIGGER     �   CREATE TRIGGER update_parking_areas_trigger AFTER UPDATE ON public.vehicles FOR EACH ROW WHEN ((old.che_area IS DISTINCT FROM new.che_area)) EXECUTE FUNCTION public.update_parking_areas_function();
 >   DROP TRIGGER update_parking_areas_trigger ON public.vehicles;
       public          postgres    false    226    996    226            D           2606    77665 )   carbonanalysis carbonanalysis_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.carbonanalysis
    ADD CONSTRAINT carbonanalysis_userid_fkey FOREIGN KEY (userid) REFERENCES public.t_user(id);
 S   ALTER TABLE ONLY public.carbonanalysis DROP CONSTRAINT carbonanalysis_userid_fkey;
       public          postgres    false    4142    211    230            A           2606    77670    vehicles fk_area    FK CONSTRAINT     �   ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT fk_area FOREIGN KEY (che_area) REFERENCES public.parkingareas(areaid) ON UPDATE CASCADE;
 :   ALTER TABLE ONLY public.vehicles DROP CONSTRAINT fk_area;
       public          postgres    false    224    226    4152            B           2606    77647 #   travelpaths travelpaths_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.travelpaths
    ADD CONSTRAINT travelpaths_userid_fkey FOREIGN KEY (userid) REFERENCES public.t_user(id);
 M   ALTER TABLE ONLY public.travelpaths DROP CONSTRAINT travelpaths_userid_fkey;
       public          postgres    false    4142    228    211            C           2606    77652 &   travelpaths travelpaths_vehicleid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.travelpaths
    ADD CONSTRAINT travelpaths_vehicleid_fkey FOREIGN KEY (vehicleid) REFERENCES public.vehicles(vehicleid);
 P   ALTER TABLE ONLY public.travelpaths DROP CONSTRAINT travelpaths_vehicleid_fkey;
       public          postgres    false    228    226    4156            �      x������ � �      �   z  x��U�NA]3_�@�^���W�3D�1!����H0�nPYI Ɵ��{��Նqz�������y�jĝ�����U��csq��}j�O~~?oN�w ����FX}���%J9gT�D���qȑJd�T�yc\�D\q69�3�v�&���*>ƿC@�f�	�9�\h��e ���d�t1*��;jMʲb��x�>p�x��S�↓A*$��|�ۻ$o*>ƿA�H�?~�\����X6`����~�]��$��V�c�m\b� ��.K��$*[��'ۧ_�1���7/�^�X:�lRb�ܐ]Aߕ3qa�r���̺r�����T��1����%��B>U|������LWϿ����D-�{u��e�����V���S�m7��I)�ԍ�oPo��}����\*�z�%��Җ��k�%������������}>�?~7E����R�{�Wϫ�"�!�~��apYer��?\�1��󚷯�z���;�nNO���ٶ��}�vRt|��#F��{��Z/+>���Ճ����l��eB���Z�u�E�^�,�\�V��ndѺ����3��A���btUI7�b������d�x�)��!����9�\����l6��Fk�            x������ � �      �   L   x�A ��1	0001	天上	2024.7.3	zsm	2145456525	电动	低于	正常	
\.


��j      �   u  x����R�P�?'O��	 �ҙ��zkg`D���h�b�N�2��U.-j
��&��W�9d�J[g�9s�L����^D���s�n��\�ۣST����v��m����w�qj�}8����ئ��}{8��"U���A~��/:�~ԡn�<��l��I��	
���rL�bEo5��w����,�au�T��[,4�R`�����g2._Hrs�.��W3�3�Lfl�f�=�x���B�O�V��*���|z�=#�!����Y�!��U�R봔��ga�b7�S�qO��y�ȇف�U��"h�^~7��:M�م�t"��K�œK�vqq5�?&�o���B">����<Q��R�a�ǌQ649Fs�c��a��mYpt8��M�*�`��E���~n>'%c�R�m^m�]oT25�/����Ƣ��IS�[�k��V�I9lx�l	�&]���KhmC���7�{(ϓG	����D��`�0[P������w�l����~�K�hPRb4�(���$Q�p�}�:�N��[�Л��^3穟ܻ6�?�]���1�+�-c7R ���R=�HTn�L���wa{ǽ� m�,�IT�5z�	JR@���cY�7;�7V      �   |   x�3�*��422��C���>���t�.s���"NCCC�g3׽l��|ʊg۹�8��]8��Mt8KR�K8�O�暚�[Xr��7�,��466�|>y���ih�8��ny9u?��=... �B"      �      x������ � �      �   �  x��ZYr#����N�(�a��S���1&@I,��g6�16U�fݖN �xx ��Mޘ�ر|}:�`�8�t$v�/ȥO
D����Eԥ7G��u������Jlީ�V���V����M�P�{���^�=�j����7�����A����⡢�r�Av�xQ9���>���\5b�ֵ��Y��j�&o��-�?5(|7H�O�5z�pp�t����4\����#9�f���x���7Ye�d
y=$>�(�t��32�7M��+h2W�G`�d,G�j7�ZS�]+�b
!�i��E�E���.��#��1�2��1���,z`�p#���)dk������`Q�C�E�[$�f��.ć8N!.������ez��_��Eћ7ɱj�>
�zi�C��a�[�ZD�-��k�E�}�X$�]-�)����>��btf��hWg�7�9w�:}��IO-�Q��Pj����������,5���GQ����7�gu(�XZ��f���S��E3}m�F����I�Z��K���D�Q�gWYB�F��Z˽ ������D?�#�nQ������`�����.���#9"�(j�%F��6HCS�H�,aF��σfwt$��/�P
X�F.��k�&���#�g�F�="�}H0��t�SƖz�t�q��c�67]��O�)�� G�H�=�X�.�޻R�%�ů��Ԣ�Ӣ�9r�'w������+8��3?2�9D&��yΞt��2������E�<��O6?�W���Eׅ��# ��Qa��$�V8�<6�99�")�d섎�Z�~��QN�[q�$:1
_df��E.D��Gm�Ox�(z-�͢�ZE��G�g���!����8��$��"�9܇������å������f�r��Y����i�W��!��E���Fpۍ΀�X�p�Ƈlĵ��
>�D��{����*��-D�N����F�t�+�fj��M�b2��#{�F��C�uт�����Iz�i��1��d4)��6��/�}eM�M�vMy�*��UQ�����@�>�\S3�!������&+nd4=�̑���I
��J�(q�c�!v=g�4.�5�m�jj��x����/.��D/��k�~}K��;v��,�����Ti.:�I ���%��+��ib�S9��C,�
���g#\i�O�#�Ͼ\;qnpd��ʉ�P�H��/1m���CJ� 嶾�@�;'N���q��|�Q*d֋8�O�w�C�#C����!��q.-S�A��g�[��;�)tf��5�[�2����`�c�:?t6*,{���39����ͨ���I,Y�b'��B��lO�@��0x��+�VK��Od}����5S���c�c�7(�_�9GYh�Oj����av�Z{��v��"⣊0�2�¯������Odbg��e���g$N��f{<3»(����b%?n�Ht��-wUs�p���.}e�S��R��k�P�Η�p"Nu�U���&!�'^�  �o���T���Y�ӡ�1PQ��5=t�N�#i~}��b�C�?"#e�#�-��aԘ�V
�?D��߶����24�9�5�o)�7�o%"��*�J�<t�����$3���o:�N�tma`Z	�ܬ��;����6�g7�1��g���s�*�2\OU$�$	���h�g�֧J�f�v�#�K�e\b�Ѧ���RlW?�_7�+�S�8Fi�H ��Ϳ�#m��Ti�c�� E���y�Dm
�:�PM����1t�YQ��x�w������ԧE�~}�gE��������h@�N�(�u�"�1�ڊ���;��p�#t/AWFWn)7H��á��2��B_�CMe�^u7U�JL=��?��2m�
�������q]L�mB�]����<� h�?H�^9��_�1�y�����dA�ʉ���D5�n�����|G�[_������?�ų���_ވ+���:��q%��Ų��/��ثAm���wTZp=�e���<��2 ����x�l2���v~q04���6K�
68%�S�W%+���
��Da��®�EL`/<BO�x��3���]\
����q���Yql����u3~����M����̣V+'~߂S#&����#:~@Y����""�_�	�@��[�Pxq�rӘ�c�ײEg@�K����V�޿��r����F�%�2$�)O�C��忷(r�x���(ލ���K�m�����㥓�xP���Y��ڤa/2Ν�A� ������(CaQ��^��cf���ty;��q�m���~�.P(�c������9%q[��TX�l�$F3�u�`H��ҷFAWD�O<����X���@��z��Vq�{ ��A�����g[�ͨ��10���� 1%�q�;�f��b<t͕ѭ��[]��;�$���u�D0ʉ�4�4�bD����GN۱����2<��������Ŋ?�\�a���c	{L_��;�/ͺG3���抗���^�e
�.5��޻�D�Y�'O��o�r���r�c�����S�pI�ߟ?ͯ6�v�`@�5z����a����xB�	�k��<������*�n���	�u�a@�Aҷ9I��w�B�hq��Y0w-���CK����?��A�$��A��a���c��]9�`ܗ��nJ��_��U�MMqedx�z��D�&�P��CB���?J�G��(�%����9J���w�G�<?��������n�򺹤�<�ؔ�ai-�.�1��nJ����:�vux�|5jM��$��kb�(Ⱥ)#	h������{�a�	��d�6����uw��!����=�u$dDܔ7�܈���?s�B��-)P�dy� }D6%"3P��X��T��Ƌ�G��n��:����׽J����Q\�!���r�I�݃f��k�l�\�}S�HjD����������jI���p��^}��cGE�=�J6�L��I��9@�cHt�\o���� ��fg���M#�ǘ{cX�{w�}���d:��?o���{V��n��b���kE���}���>6p\��.%��H"��������0�ߧ��7޴i�b�cCP���m�qهtҺɺc��A��C���9i3��ET���uS�|�k�"EѰ/iKD�}�Yo"��KĞ'��2Ac0�6|��Db���4Y��/���a���_�������l�R+[�ܿDGG����
���������u��M�8\7*�ی8�sO��g@f�Ԝ�"8Z�����|m(�eߨ�WҪ?��1���(��\9쏅Z�d�:҉���o���Q���?;v��Px�?����.�e����H��p;��v��x�I���&ux��V�����KrK+4�M�c�������g:2�����1Ԃ"u}��9��D����͜1��������`h      �     x���ϊ�F��ڧ�{�U��&���yC���8�9��C��8��!�`>��1�����[����JJK���.b`w4��ꫯJHջo���$������w/޾���t{y�ٽ���'�*H�7 �[�y�����
�
�.X	�>(�N/D$��奈��{���Z
Rt7�a6n_�s�..$V gh�s��������E��?y����)@���e�C5�J�[ѐu�BA�$�P�/����߿�o�����ͷ&Q`�F�l��I*iF'�I�0�A��0�ic��S�o���?�?{6���3�L��Ӊ*3g͘J-S�^.@����o����^�� ��l���\�Q�ź�ۣ|u���qb.�v�~�cw�p@%T�k�Z��ۿ/��X+r���f��D������4U@�$�_�<�e4�Ќ��-V��v=��XPjh5�@Z�6��lE3���`$��������|9 �0��
2X���Q���p�Dc�-�W�_��^�0�rG��h�����E�ٮ���F�",x�M�F���97�Fhv�'�N����Ӹ�R\ ��t�Pȵ��濵��Ү����P]�.���8�Ob@)1 �,�����T�h�+���� �Lf��'a��@�`2�<I�t�P��Շ��U��l�i\@).�q�]5{4�J��z�����U�'-ŅK|�T@i�8�o5sk�����uQ=�(eF���ԋ&sk�/1Oq>s�aꢼ���S+�J��uC02�~��-�X�f5��$�s!.�o��|N������3�K}��q�?�r�u�d\(C+5�H�^AJ�")G�s�<����kj2�M�u���2y��s:.�@ӂ���K��]|��r����P���Z{2^V-+�{c޿�n0FW���!|����l���>�6|�0Ĉ�^+�W��5~R9���q�^�X�`��:��Óվ��=���j?VJ���H�Y#�ɸ�X�Ȱ�5o62[;�6(~���ݽsvv�/��B     