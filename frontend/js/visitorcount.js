// GET API REQUEST
async function get_visitors() {
  const el = document.getElementById('visitors');
  try {
    const response = await fetch('https://2ohetm89ie.execute-api.us-east-1.amazonaws.com/counter', {
      method: 'GET'
    });
    const data = await response.json();
    el.textContent = (data && typeof data.count !== 'undefined') ? data.count : '—';
    return data;
  } catch (err) {
    console.error('visitor api error:', err);
    if (el) el.textContent = '—';
  }
}

get_visitors();