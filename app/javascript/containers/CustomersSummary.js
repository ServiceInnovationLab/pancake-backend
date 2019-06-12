
import React, { Fragment } from 'react';
import 'isomorphic-fetch';

import { requestBuilder } from '../helpers/requestBuilder';
import { find } from 'lodash';
import { ProcessButtons } from '../components/ProcessButtons';
import { BatchesSummary } from '../components/BatchesSummary';
import { SummaryTable } from '../components/SummaryTable';
import { SummarySearch } from '../components/SummarySearch';
import { SummaryTabs } from '../components/SummaryTabs';

const pathname = window.location.pathname;
const location = pathname.substring(pathname.lastIndexOf('/') + 1);

class CustomersSummary extends React.Component {
  constructor(props) {
    super(props);
    const { batches, rebateForms, current_user_roles } = this.props;

    this.unProcessRebates = this.unProcessRebates.bind(this);
    this.createBatch = this.createBatch.bind(this);
    this.fetchRebatesByName = this.fetchRebatesByName.bind(this);
    this.state = {
      checked: [],
      batches: batches && JSON.parse(batches),
      rebateForms: rebateForms && JSON.parse(rebateForms),
      isDiaUser: !!find(current_user_roles, role => role.name === 'dia'),
      isCouncilUser: !!find(current_user_roles, role => role.name === 'rates' || role.name === 'frontline')
    };
  }

  checkIt(key) {
    const rebateFormId = this.state.rebateForms[key].id;
    let { checked } = this.state;

    const index = checked.indexOf(rebateFormId);

    index !== -1
      ? checked.splice(index, 1)
      : checked.push(rebateFormId);

    this.setState({
      checked: [...checked]
    });
  }

  unProcessRebates() {
    requestBuilder({
      method: 'DELETE',
      path: '/admin/unprocess_rebate_forms',
      body: JSON.stringify({ ids: this.state.checked })
    }).then(() => {
      window.location = '/admin/rebate_forms/processed';
    });
  }

  createBatch() {
    requestBuilder({
      method: 'POST',
      path: '/admin/batches',
      body: JSON.stringify({ ids: this.state.checked })
    }).then(() => {
      window.location = '/admin/batches';
    });
  }

  fetchRebates(name) {
    requestBuilder({
      method: 'get',
      path: `${pathname}?utf8=✓&name=${name || ''}`,
    })
      .then(response => {
        return response.json();
      })
      .then(data => {
        this.setState({ rebateForms: JSON.parse(data.json) });
      })
      .catch(error => {
        console.error(error);
      });
  }

  fetchRebatesByName(values = {}) {
    this.fetchRebates(values.name);
  }

  render() {
    const { batches, rebateForms, checked, isDiaUser, isCouncilUser } = this.state;

    const processable = pathname === '/admin/rebate_forms/processed' &&
    (rebateForms && rebateForms[0]);
    const checkIt = processable ? this.checkIt.bind(this) : null;

    return (
      <Fragment>
        <div className='pure-u-1-2 rebate-search-box'>
          {SummaryTabs()}
          { (location === 'admin') && SummarySearch(this.fetchRebatesByName)}
        </div>
        <div className='flex-row rebate-bulk-actions'>
          <h3>{batches && batches[0] ? 'Batches' : 'Search Results'}</h3>
          {processable && ProcessButtons(
            {
              disabled: Boolean(!checked[0]),
              unProcessRebates: this.unProcessRebates,
              createBatch: this.createBatch
            }
          )}
        </div>
        {(batches && batches[0]) && BatchesSummary(batches, isDiaUser, isCouncilUser)}
        {(rebateForms && rebateForms[0]) && SummaryTable(rebateForms, checked, checkIt)}
      </Fragment>
    );
  }
}

export default CustomersSummary;
