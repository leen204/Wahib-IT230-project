/* app.js - Wahib core storage + helpers (single source of truth) */

const LS_KEYS = {
  role: 'wahib_role',            // 'hospital' | 'donor' | ''
  account: 'wahib_account',      // بيانات المستخدم الحالي (object)
  requests: 'wahib_requests',    // all requests (array)
  appts: 'wahib_appointments',   // appointments (array)
  eligible: 'wahib_eligible',    // boolean
  lastEligPing: 'wahib_last_elig_ping',
  selectedReq: 'wahib_selected_request' // temp selection for booking
};
/* ===== Fake donation history (simple) =====
   ضع هذا في app.js بعد تعريف LS أو بعد البلوك seed */
const HISTORY_KEY = 'wahib_history';
function getHistory(){ return JSON.parse(localStorage.getItem(HISTORY_KEY) || '[]'); }
function setHistory(arr){ localStorage.setItem(HISTORY_KEY, JSON.stringify(arr)); }

// seed بيانات وهمية — ستحفظ لو لم تكن موجودة
(function seedFakeHistory(){
  if(localStorage.getItem(HISTORY_KEY)) return;
  const demo = [
    { id: 201, date:'2024-03-12', hospital:'King Khalid Hospital', city:'Riyadh', blood:'A-', notes:'Routine donation' },
    { id: 202, date:'2023-11-02', hospital:'King Fahad Medical City', city:'Riyadh', blood:'A-', notes:'Emergency drive' },
    { id: 203, date:'2022-07-20', hospital:'Riyadh Central Hospital', city:'Riyadh', blood:'A-', notes:'Community camp' }
  ];
  setHistory(demo);
})();


/* === Storage helpers === */
function getRole(){ return localStorage.getItem(LS_KEYS.role) || ''; }
function setRole(v){ localStorage.setItem(LS_KEYS.role, v || ''); }
function getAcc(){ return JSON.parse(localStorage.getItem(LS_KEYS.account) || '{}'); }
function setAcc(obj){ localStorage.setItem(LS_KEYS.account, JSON.stringify(obj || {})); }

function getReqs(){ return JSON.parse(localStorage.getItem(LS_KEYS.requests) || '[]'); }
function setReqs(arr){ localStorage.setItem(LS_KEYS.requests, JSON.stringify(arr || [])); }

function getAppts(){ return JSON.parse(localStorage.getItem(LS_KEYS.appts) || '[]'); }
function setAppts(arr){ localStorage.setItem(LS_KEYS.appts, JSON.stringify(arr || [])); }

function getEligible(){ return JSON.parse(localStorage.getItem(LS_KEYS.eligible) || 'false'); }
function setEligible(v){ localStorage.setItem(LS_KEYS.eligible, JSON.stringify(!!v)); }

function setSelectedReq(r){ localStorage.setItem(LS_KEYS.selectedReq, JSON.stringify(r || null)); }
function getSelectedReq(){ return JSON.parse(localStorage.getItem(LS_KEYS.selectedReq) || 'null'); }

/* === Seed demo data (only if empty) === */
(function seed(){
  if(!localStorage.getItem(LS_KEYS.requests)){
    setReqs([
      {id:1,hospital:"King Khalid Hospital",city:"Riyadh",location:"North Wing",blood:"A-",quantity:3,status:"Emergency"},
      {id:2,hospital:"King Khalid Hospital",city:"Riyadh",location:"Main Campus",blood:"O+",quantity:5,status:"Open"},
      {id:3,hospital:"King Fahad Medical City",city:"Riyadh",location:"Main",blood:"B+",quantity:6,status:"Open"},
      {id:4,hospital:"Riyadh Central Hospital",city:"Riyadh",location:"Campus",blood:"AB+",quantity:4,status:"Emergency"}
    ]);
  }
  if(!localStorage.getItem(LS_KEYS.appts)) setAppts([]);
})();

/* === Auth flow used by login/signup pages === */
function login(payload){
  const { role } = payload || {};
  // simple validation
  if(!payload.email || !/^[^@]+@[^@]+\.[^@]+$/.test(payload.email)) return toast('Please enter a valid email','err');
  if(!payload.password || payload.password.length < 8) return toast('Password must be at least 8 characters','err');

  if(role === 'hospital'){
    setRole('hospital');
    setAcc({
      hospitalName: payload.hospitalName || 'My Hospital',
      region: payload.city || 'Riyadh',
      contact: payload.contact || '011-0000000',
      email: payload.email
    });
    location.href = 'hospital_dashboard.html';
  } else { // donor
    if(payload.phone && !/^\d{9,10}$/.test(payload.phone)) return toast('Phone must be 9-10 digits','err');
    setRole('donor');
    setAcc({
      name: payload.name || 'Donor User',
      blood: payload.blood || 'O+',
      phone: payload.phone || '',
      email: payload.email
    });
    location.href = 'donor_home.html';
  }
}

/* logout convenience */
function logout(){
  setRole('');
  // keep account if you want; here we clear role only as desired in spec
  location.href = 'index.html';
}

/* === Requests / Appointments === */
function addRequest(rec){
  const list = getReqs();
  const id = list.length ? Math.max(...list.map(r=>r.id)) + 1 : 1;
  const item = { id, ...rec };
  list.push(item);
  setReqs(list);
  return item.id;
}

function addAppointment({hospital,city,blood,date,time,requestId}){
  const a = getAppts();
  const id = Date.now();
  a.push({id,hospital,city,blood,date,time,requestId,bookedAt:new Date().toISOString()});
  setAppts(a);
  return id;
}

function updateAppointment(id, patch){
  const a = getAppts();
  const idx = a.findIndex(x=>x.id===id);
  if(idx===-1) return false;
  a[idx] = {...a[idx], ...patch};
  setAppts(a);
  return true;
}

function removeAppointment(id){
  const a = getAppts().filter(x=> x.id !== id);
  setAppts(a);
}

/* helper: does user already have appointment? (only one allowed) */
function hasActiveAppt(){
  return getAppts().length > 0;
}

/* compatibility helpers for older code naming */
const getAccount = getAcc;
const setAccount = setAcc;
const getRequests = getReqs;
const setRequests = setReqs;

/* === small utilities (toasts / confirm) === */
function toast(msg, type='ok'){
  // uses #w-toast element if exists else creates ephemeral toast
  let el = document.getElementById('w-toast');
  if(!el){
    el = document.createElement('div');
    el.id = 'w-toast';
    document.body.appendChild(el);
  }
  el.textContent = msg;
  el.className = (type==='err') ? 'err' : 'ok';
  el.style.display = 'block';
  setTimeout(()=>{ el.style.display='none'; }, 2000);
}

/* simple confirm modal that returns a Promise<bool> */
function confirmBox(message='Are you sure?', title='Confirm'){
  return new Promise(resolve=>{
    let bg = document.getElementById('w-confirm');
    if(!bg){
      // create fallback confirm UI
      bg = document.createElement('div');
      bg.id='w-confirm';
      bg.innerHTML = `<div class="box"><h3 id="w-confirm-title">${title}</h3><p id="w-confirm-msg">${message}</p><div class="actions"><button id="w-cancel">Cancel</button><button id="w-ok">Yes</button></div></div>`;
      document.body.appendChild(bg);
      document.getElementById('w-cancel').addEventListener('click',()=>{ bg.style.display='none'; resolve(false); });
      document.getElementById('w-ok').addEventListener('click',()=>{ bg.style.display='none'; resolve(true); });
    }
    // if exists in DOM already, reuse placeholders
    const titleEl = document.getElementById('w-confirm-title');
    const msgEl = document.getElementById('w-confirm-msg');
    const okBtn = document.getElementById('w-ok');
    const cancelBtn = document.getElementById('w-cancel');
    if(titleEl) titleEl.textContent = title;
    if(msgEl) msgEl.textContent = message;
    // show modal
    if(bg) bg.style.display='flex';
    // temporary listeners
    const done = (v) => {
      if(bg) bg.style.display='none';
      okBtn.removeEventListener('click', onOk);
      cancelBtn.removeEventListener('click', onCancel);
      resolve(v);
    };
    function onOk(){ done(true); }
    function onCancel(){ done(false); }
    okBtn.addEventListener('click', onOk);
    cancelBtn.addEventListener('click', onCancel);
  });
}

/* small helper for checking blood compatibility (simple equality or O universal) */
function canDonate(donorBlood, neededBlood){
  if(!donorBlood || !neededBlood) return false;
  if(donorBlood === neededBlood) return true;
  if(donorBlood === 'O-') return true; // simplification
  // AB+ can receive all but cannot donate to others — keep simple
  return false;
}
