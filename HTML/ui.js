/* ui.js - render header + eligibility reminder + small UI helpers (no HTML <script> wrapper) */

(function renderHeader(){
  // if header already exists with data-wahib attribute, skip to avoid duplicates
  if(document.querySelector('header[data-wahib]')) return;

  const role = localStorage.getItem('wahib_role') || '';
  const acc = JSON.parse(localStorage.getItem('wahib_account') || '{}');

  const header = document.createElement('header');
  header.setAttribute('data-wahib','');
  header.style.cssText = "display:flex;justify-content:space-between;align-items:center;background:#b91c1c;color:#fff;padding:12px 20px;position:sticky;top:0;z-index:20";
  header.innerHTML = `
    <div id="logoBtn" style="display:flex;gap:10px;align-items:center;cursor:pointer">
      <img src="Logo.png" alt="Wahib" style="height:38px;border-radius:8px">
      <strong style="font-size:18px">Wahib</strong>
    </div>
    <nav id="navArea" style="display:flex;align-items:center;gap:18px"></nav>
  `;
  // If there's an empty placeholder header in page (class w-header), replace it, otherwise prepend
  const placeholder = document.querySelector('.w-header');
  if(placeholder){
    placeholder.replaceWith(header);
  } else {
    document.body.prepend(header);
  }

  const nav = document.getElementById('navArea');
  if(!role){
    nav.innerHTML = `<a href="signup.html" style="color:#fff;font-weight:700;text-decoration:none">Sign Up</a>
                     <a href="login.html" style="color:#fff;font-weight:700;text-decoration:none">Login</a>`;
  } else {
    const name = role==='hospital' ? (acc.hospitalName || 'Hospital') : (acc.name || 'Donor');
    nav.innerHTML = `
      <div style="position:relative">
        <button id="avatarBtn" style="display:flex;align-items:center;gap:10px;background:#fff;border:0;border-radius:999px;padding:6px 10px;cursor:pointer;color:#b91c1c;font-weight:700">
          <span style="width:28px;height:28px;border-radius:50%;background:#b91c1c;color:#fff;display:inline-flex;align-items:center;justify-content:center">${(name[0]||'U').toUpperCase()}</span>
          <span style="margin-left:6px">${name}</span>
        </button>
        <div id="menuDrop" style="position:absolute;right:0;top:46px;background:#fff;color:#333;border:1px solid #eee;border-radius:12px;box-shadow:0 12px 30px rgba(0,0,0,.12);display:none;min-width:180px;overflow:hidden">
          ${role==='hospital'
            ? `<a href="hospital_dashboard.html" style="display:block;padding:10px 12px;text-decoration:none;color:#333">Dashboard</a>
               <a href="add_request.html" style="display:block;padding:10px 12px;text-decoration:none;color:#333">Add Request</a>
               <a href="hospital_profile.html" style="display:block;padding:10px 12px;text-decoration:none;color:#333">Profile</a>`
            : `<a href="donor_home.html" style="display:block;padding:10px 12px;text-decoration:none;color:#333">Home</a>
               <a href="profile.html" style="display:block;padding:10px 12px;text-decoration:none;color:#333">Profile</a>`
          }
          <button id="logoutBtn" style="display:block;width:100%;text-align:left;padding:10px 12px;border:0;background:#fff;color:#b91c1c;font-weight:700;cursor:pointer">Logout</button>
        </div>
      </div>`;
    const btn = document.getElementById('avatarBtn');
    const drop = document.getElementById('menuDrop');
    btn.addEventListener('click', ()=> drop.style.display = drop.style.display==='block' ? 'none' : 'block');
    document.addEventListener('click', (e)=>{ if(!btn.contains(e.target) && !drop.contains(e.target)) drop.style.display='none'; });
    document.getElementById('logoutBtn').addEventListener('click', ()=>{ setRole(''); location.href='index.html'; });
  }

  // logo click route
  document.getElementById('logoBtn').addEventListener('click', ()=>{
    const r = localStorage.getItem('wahib_role') || '';
    if(r==='hospital') location.href='hospital_dashboard.html';
    else if(r==='donor') location.href='donor_home.html';
    else location.href='index.html';
  });
})();

/* Eligibility gentle reminder for donors (display once per page load; small top bar) */
(function eligReminder(){
  const role = localStorage.getItem('wahib_role') || '';
  if(role !== 'donor') return;
  const last = parseInt(localStorage.getItem('wahib_last_elig_ping') || '0', 10);
  if(Date.now() - last < 5000) return; // reduce repetition during fast reload
  localStorage.setItem('wahib_last_elig_ping', Date.now().toString());

  const bar = document.createElement('div');
  bar.style.cssText = 'position:fixed;top:0;left:0;right:0;background:#fff8e1;border-bottom:1px solid #ffe08a;padding:10px 16px;z-index:60;display:flex;justify-content:center;gap:10px;align-items:center;font-weight:700;color:#8a6d00';
bar.innerHTML = `💡 Eligibility: Please make sure your test is up to date. <a href="eligibility_test.html" style="color:#b91c1c;text-decoration:underline">Take test</a>`;
  document.body.appendChild(bar);
  document.getElementById('closeElig').addEventListener('click', ()=> bar.remove());
  setTimeout(()=>{ if(bar.parentNode) bar.remove(); }, 6000);
})();
