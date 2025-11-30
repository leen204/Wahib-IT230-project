/* ==== Wahib Clean Footer (Minimal Elegant Version - No Quick Links) ==== */
function buildFooter() {
  let el = document.querySelector('footer');
  if (!el) {
    el = document.createElement('footer');
    document.body.appendChild(el);
  }

  const year = new Date().getFullYear();

  el.innerHTML = `
    <style>
      footer {
        background: #b91c1c;
        color: #fff;
        padding: 40px 0 25px;
        border-top: 4px solid #a71a1a;
        margin-top: 60px;
        font-family: 'Poppins', sans-serif;
      }
      .f-container {
        max-width: 1100px;
        margin: 0 auto;
        padding: 0 16px;
      }
      .f-top {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        gap: 40px;
        margin-bottom: 30px;
      }
      .f-section h3 {
        font-weight: 700;
        margin-bottom: 12px;
        color: #fff;
        font-size: 18px;
      }
      .f-section p {
        line-height: 1.6;
        opacity: 0.9;
        font-weight: 500;
      }
      .f-section ul {
        list-style: none;
        padding: 0;
      }
      .f-section ul li {
        margin-bottom: 6px;
        font-weight: 500;
      }
      .f-bottom {
        border-top: 1px solid #ffffff3a;
        padding-top: 16px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 12px;
        font-weight: 500;
      }
      @media(max-width:700px) {
        .f-top { flex-direction: column; gap: 20px; }
        .f-bottom { flex-direction: column; text-align: center; }
      }
    </style>

    <div class="f-container">
      <div class="f-top">
        <div class="f-section">
          <h3>About Wahib</h3>
          <p>Wahib is a digital platform that connects blood donors with hospitals efficiently. Our goal is to simplify the donation process, save time, and save lives.</p>
          <ul>
            <li><strong>Goal 1:</strong> Increase blood donation awareness.</li>
            <li><strong>Goal 2:</strong> Support hospitals with real-time requests.</li>
            <li><strong>Goal 3:</strong> Build a reliable donor network.</li>
          </ul>
        </div>

        <div class="f-section">
          <h3>Contact Us</h3>
          <ul>
            <li><strong>Phone:</strong> +966 55 123 4567</li>
            <li><strong>Email:</strong> wahib@gmail.com</li>
            <li><strong>Address:</strong> Riyadh, Saudi Arabia</li>
          </ul>
        </div>
      </div>

      <div class="f-bottom">
        <div>© ${year} Wahib Platform. All Rights Reserved.</div>
      </div>
    </div>
  `;
}

document.addEventListener('DOMContentLoaded', buildFooter);
