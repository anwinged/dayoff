import qs from 'qs';

const PROFILE_QUERY = 'profile';

function extract_profile_id() {
  const haystack = window.location.search || window.location.hash;
  const q = haystack.substring(haystack.indexOf('?') + 1, haystack.length);
  const query = qs.parse(q);
  const profile = query[PROFILE_QUERY] || '';
  return profile;
}

async function check_profile(profileId) {}

async function get_status(profileId) {
  const response = await fetch('/api/status?profile_id=' + profileId, {
    method: 'GET',
  });
  const data = await response.json();
  return data;
}

async function start(profileId) {
  const response = await fetch('/api/start?profile_id=' + profileId, {
    method: 'POST',
  });
}

async function finish(profileId) {
  const response = await fetch('/api/finish?profile_id=' + profileId, {
    method: 'POST',
  });
}

export default { extract_profile_id, check_profile, get_status, start, finish };
