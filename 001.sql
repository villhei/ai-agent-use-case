-- Cleanups

drop function if exists public.set_updated_at cascade;
drop schema if exists public cascade;

-- Common parts of the SQL schema,

create schema public;

create function public.set_updated_at() returns trigger as $$
begin
  new.updated_at := current_timestamp;
  return new;
end;
$$ language plpgsql;

--- The main schema

-- Table for User
create table public.user (
    id uuid not null default gen_random_uuid(), -- Primary key
    email text not null, -- Email address
    first_name text not null, -- First name
    last_name text not null, -- Last name
    created_at timestamp not null default current_timestamp, -- Creation timestamp
    updated_at timestamp, -- Update timestamp
    primary key (id)
);

comment on table public.user is 'Stores user information.';
comment on column public.user.email is 'Email address of the user.';
comment on column public.user.first_name is 'First name of the user.';
comment on column public.user.last_name is 'Last name of the user.';
comment on column public.user.created_at is 'Timestamp when the record was created.';
comment on column public.user.updated_at is 'Timestamp when the record was last updated.';

-- Table for Post
create table public.post (
    id uuid not null default gen_random_uuid(), -- Primary key
    author_id uuid not null references public.user(id) on delete cascade, -- Foreign key to User
    content text not null, -- Post content
    created_at timestamp not null default current_timestamp, -- Creation timestamp
    updated_at timestamp, -- Update timestamp
    primary key (id)
);

comment on table public.post is 'Stores posts created by users.';
comment on column public.post.author_id is 'Reference to the User table.';
comment on column public.post.content is 'Content of the post.';
comment on column public.post.created_at is 'Timestamp when the record was created.';
comment on column public.post.updated_at is 'Timestamp when the record was last updated.';

-- Table for Comment
create table public.comment (
    id uuid not null default gen_random_uuid(), -- Primary key
    post_id uuid not null references public.post(id) on delete cascade, -- Foreign key to Post
    author_id uuid not null references public.user(id) on delete cascade, -- Foreign key to User
    content text not null, -- Comment content
    created_at timestamp not null default current_timestamp, -- Creation timestamp
    updated_at timestamp, -- Update timestamp
    primary key (id)
);

comment on table public.comment is 'Stores comments on posts.';
comment on column public.comment.post_id is 'Reference to the Post table.';
comment on column public.comment.author_id is 'Reference to the User table.';
comment on column public.comment.content is 'Content of the comment.';
comment on column public.comment.created_at is 'Timestamp when the record was created.';
comment on column public.comment.updated_at is 'Timestamp when the record was last updated.';

-- Trigger setup for updated_at
create trigger set_updated_at_user
before update on public.user
for each row
execute function public.set_updated_at();

create trigger set_updated_at_post
before update on public.post
for each row
execute function public.set_updated_at();

create trigger set_updated_at_comment
before update on public.comment
for each row
execute function public.set_updated_at();